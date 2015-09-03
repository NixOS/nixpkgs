{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.nginx;

  defaultSSL = cfg.httpDefaultKey != null || cfg.httpDefaultCertificate != null;

  validSSL = key: cert: cert != null && key != null || cert == null && key == null;

in

{
  options = {

    services.nginx = {

      reverseProxies = mkOption {
        type = types.attrsOf (types.submodule (
          {
            options = {
              proxy = mkOption {
                type = types.str;
                default = [];
                description = ''
                  Exclude files and directories matching these patterns.
                '';
              };

              key = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = ''
                  Exclude files and directories matching these patterns.
                '';
              };

              certificate = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = ''
                  Exclude files and directories matching these patterns.
                '';
              };
            };
          }
        ));

        default = {};

        example = literalExample ''
          {
            "hydra.yourdomain.org" =
              { proxy = "localhost:3000";
                key = "/etc/nixos/certs/hydra_key.key";
                certificate = "/etc/nixos/certs/hydra_cert.crt";
              };
          }
        '';

        description = ''
          A reverse proxy server configuration is created for every attribute.
          The attribute name corresponds to the name the server is listening to,
          and the proxy option defines the target to forward the requests to.
          If a key and certificate are given, then the server is secured through
          a SSL connection. Non-SSL requests on port 80 are automatically
          re-directed to the SSL server on port 443.
        '';
      };

      httpDefaultKey = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/nixos/certs/defaut_key.key";
        description = ''
           Key of SSL certificate for default server.
           The default certificate is presented by the default server during
           the SSL handshake when no specialized server configuration matches
           a request.
           A default SSL certificate is also helpful if browsers do not
           support the TLS Server Name Indication extension (SNI, RFC 6066).
        '';
      };

      httpDefaultCertificate = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/nixos/certs/defaut_key.crt";
        description = ''
           SSL certificate for default server.
           The default certificate is presented by the default server during
           the SSL handshake when no specialized server configuration matches
           a request.
           A default SSL certificate is also helpful if browsers do not
           support the TLS Server Name Indication extension (SNI, RFC 6066).
        '';
      };

    };

  };


  config = mkIf (cfg.reverseProxies != {}) {

    assertions = [
      { assertion = all id (mapAttrsToList (n: v: validSSL v.certificate v.key) cfg.reverseProxies);
        message = ''
          One (or more) reverse proxy configurations specify only either
          the key option or the certificate option. Both certificate
          with associated key have to be configured to enable SSL for a
          server configuration.

          services.nginx.reverseProxies: ${toString cfg.reverseProxies}
        '';
      }
      { assertion = validSSL cfg.httpDefaultCertificate cfg.httpDefaultKey;
        message = ''
          The default server configuration specifies only either the key
          option or the certificate option. Both httpDefaultCertificate
          with associated httpDefaultKey have to be configured to enable
          SSL for the default server configuration.

          services.nginx.httpDefaultCertificate: ${toString cfg.httpDefaultCertificate}

          services.nginx.httpDefaultKey : ${toString cfg.httpDefaultKey}
        '';
      }
    ];

    services.nginx.config = mkBefore ''
      worker_processes 1;
      error_log logs/error.log debug;
      pid logs/nginx.pid;
      events {
         worker_connections  1024;
      }
    '';

    services.nginx.httpConfig = mkBefore ''
      log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                '$status $body_bytes_sent "$http_referer" '
                '"$http_user_agent" "$http_x_forwarded_for"';
      access_log  logs/access.log  main;
      sendfile        on;
      tcp_nopush      on;
      keepalive_timeout  10;
      gzip            on;

      ${lib.optionalString defaultSSL ''
      ssl_session_cache    shared:SSL:10m;
      ssl_session_timeout  10m;
      ssl_protocols        TLSv1 TLSv1.1 TLSv1.2;
      ssl_ciphers          HIGH:!aNULL:!MD5;
      ssl_certificate      ${cfg.httpDefaultCertificate};
      ssl_certificate_key  ${cfg.httpDefaultKey};
      ''}
    '';

    services.nginx.httpDefaultServer = mkBefore ''
      # reject as default policy
      server {
          listen 80 default_server;
          listen [::]:80 default_server;
          ${lib.optionalString defaultSSL "listen 443 default_server ssl;"}
          return      444;
      }
    '';

    services.nginx.httpServers =
      let
        useSSL = certificate: key: certificate != null && key != null;

        server = servername: proxy: certificate: key: useSSL: ''
          server {
            server_name ${servername};
            keepalive_timeout    70;

            ${if !useSSL then ''
            listen 80;
            listen [::]:80;
            '' else ''
            listen 443 ssl;
            ssl_session_cache    shared:SSL:10m;
            ssl_session_timeout  10m;
            ssl_certificate      ${certificate};
            ssl_certificate_key  ${key};
            ''}

            location / {
              proxy_pass ${proxy};

              ### force timeouts if one of backend is dead ##
              proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;

              ### Set headers ####
              proxy_set_header        Accept-Encoding   "";
              proxy_set_header        Host            $host;
              proxy_set_header        X-Real-IP       $remote_addr;
              proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;

              ${lib.optionalString useSSL ''
              ### Most PHP, Python, Rails, Java App can use this header ###
              #proxy_set_header X-Forwarded-Proto https;##
              #This is better##
              proxy_set_header        X-Forwarded-Proto $scheme;
              add_header              Front-End-Https   on;
              ''}

              ### By default we don't want to redirect it ####
              proxy_redirect     off;
              proxy_buffering    off;
            }
          }

          ${lib.optionalString useSSL ''
          # redirect http to https
          server {
              listen 80;
              listen [::]:80;
              server_name ${servername};
              return 301 https://$server_name$request_uri;
          }
          ''}
        '';
      in
      concatStrings (mapAttrsToList (n: v: server n v.proxy v.certificate v.key (useSSL v.proxy v.certificate)) cfg.reverseProxies);

  };

}
