# ---------- Stage 1: Build React App ----------
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy only package.json and package-lock.json first (better caching)
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy the rest of the source code
COPY . .

# Build optimized production React app
RUN npm run build


# ---------- Stage 2: Nginx Server ----------
FROM nginx:1.27-alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy build output from previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom nginx config if you have one
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
