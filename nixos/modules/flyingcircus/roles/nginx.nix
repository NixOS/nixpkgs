{ config, lib, pkgs, ... }: with lib;

let
  cfg = config.flyingcircus;

  localConfig = if pathExists /etc/local/nginx
  then "include ${/etc/local/nginx}/*.conf;"
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

    ${config.flyingcircus.roles.nginx.httpConfig}
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

      httpConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Configuration lines to be appended inside of the http {} block.";
      };

    };

  };

  config = mkIf cfg.roles.nginx.enable {

    services.nginx.enable = true;
    services.nginx.appendConfig = baseConfig;

    # XXX only on FE!
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    system.activationScripts.nginx = ''
      install -d -o ${toString config.ids.uids.nginx} /var/log/nginx
      install -d -o ${toString config.ids.uids.nginx} /etc/local/nginx
    '';

    environment.etc = {
      "local/nginx/fastcgi_params".text = ''
        fastcgi_param  QUERY_STRING       $query_string;
        fastcgi_param  REQUEST_METHOD     $request_method;
        fastcgi_param  CONTENT_TYPE       $content_type;
        fastcgi_param  CONTENT_LENGTH     $content_length;

        fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
        fastcgi_param  REQUEST_URI        $request_uri;
        fastcgi_param  DOCUMENT_URI       $document_uri;
        fastcgi_param  DOCUMENT_ROOT      $document_root;
        fastcgi_param  SERVER_PROTOCOL    $server_protocol;
        fastcgi_param  HTTPS              $https if_not_empty;

        fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
        fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;

        fastcgi_param  REMOTE_ADDR        $remote_addr;
        fastcgi_param  REMOTE_PORT        $remote_port;
        fastcgi_param  SERVER_ADDR        $server_addr;
        fastcgi_param  SERVER_PORT        $server_port;
        fastcgi_param  SERVER_NAME        $server_name;

        # PHP only, required if PHP was built with --enable-force-cgi-redirect
        fastcgi_param  REDIRECT_STATUS    200;
      '';
      } //
      (if cfg.compat.gentoo.enable
       then {
        "nginx/local".source = /etc/local/nginx;
        "nginx/fastcgi_params".source = /etc/local/nginx/fastcgi_params;
      }
      else {});
    };
  }
