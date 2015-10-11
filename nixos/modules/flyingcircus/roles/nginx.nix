{ config, lib, pkgs, ... }: with lib;

let 

    localConfig = if pathExists /etc/nginx/local
                  then "include ${/etc/nginx/local}/*.conf;"
                  else "";

    baseConfig =
        ''
        worker_processes 1;

        error_log /var/log/nginx/error_log notice;

        http {
            default_type application/octet-stream;
            charset UTF-8;

            log_format main
                '$remote_addr - $remote_user [$time_local] '
                '"$request" $status $bytes_sent '
                '"$http_referer" "$http_user_agent" '
                '"$gzip_ratio"';
            open_log_file_cache max=64;
            access_log /var/log/nginx/access.log;
            log_format performance
                '$time_iso8601 $remote_addr '
                '"$request_method $scheme://$host$request_uri" $status '
                '$bytes_sent $request_length $pipe $request_time '
                '$upstream_response_time';
            access_log /var/log/nginx/performance.log performance;

            client_header_timeout 10m;
            client_body_timeout 10m;
            send_timeout 10m;

            connection_pool_size 256;
            client_header_buffer_size 4k;
            large_client_header_buffers 4 16k;
            request_pool_size 4k;

            gzip on;
            gzip_min_length 1100;
            gzip_types application/javascript application/json
                application/vnd.ms-fontobject application/x-javascript
                application/xml application/xml+rss font/opentype font/truetype
                image/svg+xml text/css text/javascript text/plain text/xml;
            gzip_vary on;
            gzip_disable msie6;
            gzip_proxied any;

            sendfile on;
            tcp_nopush on;
            tcp_nodelay on;

            keepalive_timeout 75 20;
            reset_timedout_connection on;
            server_names_hash_bucket_size 64;
            map_hash_bucket_size 64;
            ignore_invalid_headers on;

            index index.html;
            root /var/www/localhost/htdocs;

            client_max_body_size 25m;

            proxy_buffers 8 32k;
            proxy_buffer_size 32k;
            proxy_http_version 1.1;
            proxy_read_timeout 120;
            proxy_set_header Connection "";

            fastcgi_buffers 64 4k;
            fastcgi_keep_conn on;

            # http://blog.zachorr.com/nginx-setup/
            open_file_cache max=1000 inactive=20s;
            open_file_cache_valid 30s;
            open_file_cache_min_uses 2;
            open_file_cache_errors on;

            # http://www.kuketz-blog.de/nsa-abhoersichere-ssl-verschluesselung-fuer-apache-und-nginx/
            ssl_prefer_server_ciphers on;
            ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
            ssl_ciphers "EECDH+AESGCM EDH+AESGCM EECDH EDH RSA+3DES -RC4 -aNULL -eNULL -LOW -MD5 -EXP -PSK -DSS -ADH";
            ssl_session_cache shared:SSL:10m;
            ssl_session_timeout 10m;

            ${localConfig}

        }
        '';

in
 
{

    options = {

        flyingcircus.roles.nginx = {

            enable = mkOption {
                type = types.bool;
                default = false;
                description = "Enable the Flying Circus nginx server role.";
            };

        };

    };

    config = mkIf config.flyingcircus.roles.nginx.enable {

        services.nginx.enable = true;
        services.nginx.appendConfig = baseConfig;

        jobs.fcio-stubs-nginx = {
            description = "Create FC IO stubs for nginx";
            task = true;

            startOn = "started networking";

            script = 
                ''
                    install -d -o vagrant /etc/nginx/local
                    install -d -o nginx /var/log/nginx
                '';
        };

    };
}
