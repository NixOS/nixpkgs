{ config, pkgs, ... }:

with pkgs.lib;

let
  createReverseProxySSL = {servername, proxy, certificate, key}:
      ''
      server {
          listen 443 ssl;
          server_name ${servername};
          keepalive_timeout    70;
       
          ssl_session_cache    shared:SSL:10m;
          ssl_session_timeout  10m;
          ssl_certificate      ${certificate};
          ssl_certificate_key  ${key};
       
          ### We want full access to SSL via backend ###
          location / {
            proxy_pass ${proxy};
       
            ### force timeouts if one of backend is dead ##
            proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
       
            ### Set headers ####
            proxy_set_header        Accept-Encoding   "";
            proxy_set_header        Host            $host;
            proxy_set_header        X-Real-IP       $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
       
            ### Most PHP, Python, Rails, Java App can use this header ###
            #proxy_set_header X-Forwarded-Proto https;##
            #This is better##
            proxy_set_header        X-Forwarded-Proto $scheme;
            add_header              Front-End-Https   on;
       
            ### By default we don't want to redirect it ####
            proxy_redirect     off;
            proxy_buffering    off;
          }
      }
      
      # redirect http to https
      server {
          listen 80;
          listen [::]:80;
          server_name ${servername};
          return 301 https://$server_name$request_uri;
      }
      '';

  createReverseProxy = {servername, proxy}:
      ''
      server {
          listen 80;
          listen [::]:80;
          server_name ${servername};
          keepalive_timeout    70;
       
          location / {
            proxy_pass ${proxy};
       
            ### force timeouts if one of backend is dead ##
            proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
       
            ### Set headers ####
            proxy_set_header        Accept-Encoding   "";
            proxy_set_header        Host            $host;
            proxy_set_header        X-Real-IP       $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
       
            ### By default we don't want to redirect it ####
            proxy_redirect     off;
            proxy_buffering    off;
          }
      }
      '';


  defaultServerSSLCertificate = {certificate, key}:
    ''
    ssl_session_cache    shared:SSL:10m;
    ssl_session_timeout  10m;
    ssl_certificate      ${certificate};
    ssl_certificate_key  ${key};
    '';

  defaultServerSSL = ''
    # reject as default policy
    server {
        listen 80 default_server;
        listen [::]:80 default_server;
        listen 443 default_server ssl;
        return      444;
    }
  '';

  defaultServer = ''
    # reject as default policy
    server {
        listen 80 default_server;
        listen [::]:80 default_server;
        return      444;
    }
  '';


  configNginx = ''
    worker_processes 1;
    error_log logs/error.log debug;
    pid logs/nginx.pid;
    events {
       worker_connections  1024;
    }
    '';

  httpConfig = ''
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
              '$status $body_bytes_sent "$http_referer" '
              '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  logs/access.log  main;
    sendfile        on;
    tcp_nopush      on;
    keepalive_timeout  10;
    gzip            on;
    '';

in

{
  options = {
    services.nginx = {
      reverseProxy = mkOption {
        default = [];
        example = [ { servername = "foo.bar"; proxy = "http://bar.foo"; certificate = "/file/bar.cert"; key = "/file/bar.key"; } ];
        type = types.listOf (types.attrsOf types.str);
        description = ''
           Generate reverse proxy configuration.
                      '';
      };

      defaultCertificate = mkOption {
        default = { certificate = ""; key = ""; };
        example = { certificate = "/file/bar.cert"; key = "/file/bar.key"; };
        type = types.attrsOf types.str;
        description = ''
           SSL certificates for default proxy configuration.
           It will be served during the SSL handshake for unknown proxies, before the connection is dropped.
                      '';
      };
    };
  };


  config =
    let
      useSSL = if (config.services.nginx.defaultCertificate.certificate != "" || config.services.nginx.defaultCertificate.key != "") then true else false;
 
      proxyRequiresSSL = proxyConfig: if ( ((hasAttr "certificate" proxyConfig) && (proxyConfig.certificate != "")) || ((hasAttr "key" proxyConfig) && proxyConfig.key != "")) then true else false;
 
      requestSSL = fold (item: acc: proxyRequiresSSL item || acc) false config.services.nginx.reverseProxy;

      mkAllReverseProxies = proxyConfig: if (proxyRequiresSSL proxyConfig) then (createReverseProxySSL proxyConfig) else (createReverseProxy proxyConfig);
      mkHTTPOnlyReverseProxies = proxyConfig: if (proxyRequiresSSL proxyConfig) then "" else (createReverseProxy proxyConfig);
      mkHTTPSOnlyReverseProxies = proxyConfig: if (proxyRequiresSSL proxyConfig) then (createReverseProxySSL proxyConfig) else "";
    in
      mkIf (config.services.nginx.reverseProxy != []) {
	services.nginx.config = if (requestSSL && useSSL) then
           configNginx + "http {\n" + httpConfig + defaultServerSSLCertificate config.services.nginx.defaultCertificate + concatMapStrings mkAllReverseProxies config.services.nginx.reverseProxy + defaultServerSSL + "}"
        else
          configNginx + "http {\n" + httpConfig + concatMapStrings mkHTTPOnlyReverseProxies config.services.nginx.reverseProxy + defaultServer + "}";
      };
}
     


