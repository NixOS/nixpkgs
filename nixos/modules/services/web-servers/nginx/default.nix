{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nginx;
  virtualHosts = mapAttrs (vhostName: vhostConfig:
    vhostConfig // (optionalAttrs vhostConfig.enableACME {
      sslCertificate = "/var/lib/acme/${vhostName}/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/${vhostName}/key.pem";
    })
  ) cfg.virtualHosts;

  configFile = pkgs.writeText "nginx.conf" ''
    user ${cfg.user} ${cfg.group};
    error_log stderr;
    daemon off;

    ${cfg.config}

    http {
      include ${cfg.package}/conf/mime.types;
      include ${cfg.package}/conf/fastcgi.conf;

      # optimisation
      sendfile on;
      tcp_nopush on;
      tcp_nodelay on;
      keepalive_timeout 65;
      types_hash_max_size 2048;

      # use secure TLS defaults
      ssl_protocols ${cfg.sslProtocols};
      ssl_session_cache shared:SSL:42m;
      ssl_session_timeout 23m;

      ssl_ciphers ${cfg.sslCiphers};
      ssl_ecdh_curve secp521r1;
      ssl_prefer_server_ciphers on;
      ${optionalString (cfg.sslDhparam != null) "ssl_dhparam ${cfg.sslDhparam};"}

      ssl_stapling on;
      ssl_stapling_verify on;

      gzip on;
      gzip_disable "msie6";
      gzip_proxied any;
      gzip_comp_level 9;
      gzip_buffers 16 8k;
      gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

      # sane proxy settings/headers
      proxy_set_header        Host $host;
      proxy_set_header        X-Real-IP $remote_addr;
      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header        X-Forwarded-Proto $scheme;
      proxy_set_header        Accept-Encoding "";

      proxy_redirect          off;
      client_max_body_size    10m;
      client_body_buffer_size 128k;
      proxy_connect_timeout   90;
      proxy_send_timeout      90;
      proxy_read_timeout      90;
      proxy_buffers           32 4k;
      proxy_buffer_size       8k;
      proxy_http_version      1.0;

      server_tokens ${if cfg.serverTokens then "on" else "off"};
      ${vhosts}
      ${cfg.httpConfig}
    }
    ${cfg.appendConfig}
  '';
  vhosts = concatStringsSep "\n" (mapAttrsToList (serverName: vhost:
      let
        ssl = vhost.enableSSL || vhost.forceSSL;
        port = if vhost.port != null then vhost.port else (if ssl then 443 else 80);
        listenString = toString port + optionalString ssl " ssl spdy"
          + optionalString vhost.default " default";
        acmeLocation = optionalString vhost.enableACME ''
          location /.well-known/acme-challenge {
            try_files $uri @acme-fallback;
            root ${vhost.acmeRoot};
            auth_basic off;
          }
          location @acme-fallback {
            auth_basic off;
            proxy_pass http://${vhost.acmeFallbackHost};
          }
        '';
      in ''
        ${optionalString vhost.forceSSL ''
          server {
            listen 80 ${optionalString vhost.default "default"};
            listen [::]:80 ${optionalString vhost.default "default"};

            server_name ${serverName} ${concatStringsSep " " vhost.serverAliases};
            ${acmeLocation}
            location / {
              return 301 https://$host${optionalString (port != 443) ":${port}"}$request_uri;
            }
          }
        ''}

        server {
          listen ${listenString};
          listen [::]:${listenString};

          server_name ${serverName} ${concatStringsSep " " vhost.serverAliases};
          ${acmeLocation}
          ${optionalString (vhost.root != null) "root ${vhost.root};"}
          ${optionalString (vhost.globalRedirect != null) ''
            return 301 http${optionalString ssl "s"}://${vhost.globalRedirect}$request_uri;
          ''}
          ${optionalString ssl ''
            ssl_certificate ${vhost.sslCertificate};
            ssl_certificate_key ${vhost.sslCertificateKey};
          ''}

          ${optionalString (vhost.basicAuth != {}) (mkBasicAuth serverName vhost.basicAuth)}

          ${mkLocations vhost.locations}

          ${vhost.extraConfig}
        }
      ''
  ) virtualHosts);
  mkLocations = locations: concatStringsSep "\n" (mapAttrsToList (location: config: ''
    location ${location} {
      ${optionalString (config.proxyPass != null) "proxy_pass ${config.proxyPass};"}
      ${optionalString (config.root != null) "root ${config.root};"}
      ${config.extraConfig}
    }
  '') locations);
  mkBasicAuth = serverName: authDef: let
    htpasswdFile = pkgs.writeText "${serverName}.htpasswd" (
      concatStringsSep "\n" (mapAttrsToList (user: password: ''
        ${user}:{PLAIN}${password}
      '') authDef)
    );
  in ''
    auth_basic secured;
    auth_basic_user_file ${htpasswdFile};
  '';
in

{
  options = {
    services.nginx = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "
          Enable the nginx Web Server.
        ";
      };

      package = mkOption {
        default = pkgs.nginx;
        defaultText = "pkgs.nginx";
        type = types.package;
        description = "
          Nginx package to use.
        ";
      };

      config = mkOption {
        default = "events {}";
        description = "
          Verbatim nginx.conf configuration.
        ";
      };

      appendConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Configuration lines appended to the generated Nginx
          configuration file. Commonly used by different modules
          providing http snippets. <option>appendConfig</option>
          can be specified more than once and it's value will be
          concatenated (contrary to <option>config</option> which
          can be set only once).
        '';
      };

      httpConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Configuration lines to be appended inside of the http {} block.";
      };

      stateDir = mkOption {
        default = "/var/spool/nginx";
        description = "
          Directory holding all state for nginx to run.
        ";
      };

      user = mkOption {
        type = types.str;
        default = "nginx";
        description = "User account under which nginx runs.";
      };

      group = mkOption {
        type = types.str;
        default = "nginx";
        description = "Group account under which nginx runs.";
      };

      serverTokens = mkOption {
        type = types.bool;
        default = false;
        description = "Show nginx version in headers and error pages";
      };

      sslCiphers = mkOption {
        type = types.str;
        default = "EDH+CHACHA20:EDH+AES:EECDHE+CHACHA20:ECDHE+AES:+AES128:-DSS";
        description = "Ciphers to choose from when negotiating tls handshakes.";
      };

      sslProtocols = mkOption {
        type = types.str;
        default = "TLSv1.2";
        example = "TLSv1 TLSv1.1 TLSv1.2";
        description = "Allowed TLS protocol versions.";
      };

      sslDhparam = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = literalExample "/path/to/dhparams.pem";
        description = "Path to DH parameters file.";
      };

      virtualHosts = mkOption {
        type = types.attrsOf (types.submodule (import ./vhost-options.nix {
          inherit lib;
        }));
        default = {
          localhost = {};
        };
        example = [];
        description = ''
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc."nginx/nginx.conf".source = configFile;

    systemd.services = let
      nginxCmd = "${cfg.package}/bin/nginx -c /etc/nginx/nginx.conf -p ${cfg.stateDir}";
    in
    {
      nginx-config-check = {
        description = "Nginx Webserver Server config check";
        wantedBy = [ "nginx.service" "multi-user.target" ];
        restartTriggers = [ configFile ];
        script = ''
          ${nginxCmd} -t -q
          systemctl reload nginx.service
        '';
        serviceConfig.Type = "oneshot";
      };

      nginx = {
        description = "Nginx Web Server";
        after = [ "network.target" ];
        requires = [ "nginx-config-check.service" ];
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          mkdir -p ${cfg.stateDir}/logs
          chmod 700 ${cfg.stateDir}
          chown -R ${cfg.user}:${cfg.group} ${cfg.stateDir}
        '';
        serviceConfig = {
          ExecStart = nginxCmd;
          ExecReload = "${nginxCmd} -s reload";
          Restart = "always";
          RestartSec = "5s";
          StartLimitInterval = "1min";
        };
      };
    };

    security.acme.certs = filterAttrs (n: v: v != {}) (
      mapAttrs (vhostName: vhostConfig:
        optionalAttrs vhostConfig.enableACME {
          webroot = vhostConfig.acmeRoot;
          extraDomains = genAttrs vhostConfig.serverAliases (alias: null);
        }
      ) virtualHosts
    );


    users.extraUsers = optionalAttrs (cfg.user == "nginx") (singleton
      { name = "nginx";
        group = cfg.group;
        uid = config.ids.uids.nginx;
      });

    users.extraGroups = optionalAttrs (cfg.group == "nginx") (singleton
      { name = "nginx";
        gid = config.ids.gids.nginx;
      });
  };
}
