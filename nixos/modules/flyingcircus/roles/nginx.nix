{ config, lib, pkgs, ... }: with lib;

let
  cfg = config.flyingcircus;
  fclib = import ../lib;

  localConfig = if pathExists /etc/local/nginx
  then "include ${/etc/local/nginx}/*.conf;"
  else "";

  baseConfig =
  ''
  worker_processes 1;

  error_log stderr;

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
      install -d -o ${toString config.ids.uids.nginx} -g service -m 02775 /etc/local/nginx
    '';

    services.logrotate.config = ''
        /var/log/nginx/*access*log
        /var/log/nginx/performance.log
        {
            rotate 92
            create 0644 nginx service
            postrotate
                systemctl reload nginx
            endscript
        }
    '';

    environment.etc = {

      "local/nginx/README.txt".text = ''
        Nginx is enabled on this machine.

        Put your site configuration into this directory as `*.conf`. You may
        add other files, like SSL keys, as well.

        There is an `example-configuration` here.
      '';

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

      "local/nginx/example-configuration".text = ''
        # Example nginx configuration for the Flying Circus. Copy this file into
        # 'mydomain.conf' and edit. You'll certainly want to replace www.example.com
        # with something more specific. Please note that configuration files must end
        # with '.conf' to be active. Reload with `sudo /etc/init.d/nginx reload`.
        # Managed by Puppet: do not edit this file directly. It will be overwritten!

        upstream @varnish {
            server localhost:8008;
            keepalive 100;
        }

        upstream @haproxy {
            server localhost:8002;
            keepalive 10;
        }

        upstream @app {
            server localhost:8080;
        }

        server {
            ${
              builtins.concatStringsSep "\n    "
                (lib.concatMap
                  (formatted_addr: [
                    "listen ${formatted_addr}:80;"
                    "listen ${formatted_addr}:443 ssl;"])
                  (map
                    (addr:
                      if fclib.isIp4 addr
                      then addr
                      else "[${addr}]")
                    (fclib.listenAddresses config "ethfe")))
            }

            # The first server name listed is the primary name. We remommend against
            # using a wildcard server name (*.example.com) as primary.
            server_name www.example.com example.com;

            # Redirect to primary server name (makes URLs unique).
            if ($host != $server_name) {
                rewrite . $scheme://$server_name$request_uri redirect;
            }

            # Enable SSL. SSL parameters like cipher suite have sensible defaults.
            #ssl_certificate /etc/nginx/local/www.example.com.crt;
            #ssl_certificate_key /etc/nginx/local/www.example.com.key;

            # Enable the following block if you want to serve HTTPS-only.
            #if ($server_port != 443) {
            #    rewrite . https://$server_name$request_uri redirect;
            #}
            #add_header Strict-Transport-Security max-age=31536000;

            # Uncomment the following line to strip IP addresses in access logs
            #access_log /var/log/nginx/''${server_name}_access.log anonymized;

            location / {
                # Example for passing virtual hosting details to Zope apps
                #rewrite (.*) /VirtualHostBase/http/$server_name:$server_port/APP/VirtualHostRoot$1 break;
                #proxy_pass http://@varnish;

                # enable mod_security - custom mod_security configuration should go into
                # /etc/nginx/modsecurity/local.conf
                #ModSecurityEnabled on;
                #ModSecurityConfig /etc/nginx/modsecurity/modsecurity.conf;
            }
        }
        '';
      "nginx/local" = {
        source = /etc/local/nginx;
        enable = cfg.compat.gentoo.enable;
      };
      "nginx/fastcgi_params" = {
        source = /etc/local/nginx/fastcgi_params;
        enable = cfg.compat.gentoo.enable;
      };
    };
  };
}
