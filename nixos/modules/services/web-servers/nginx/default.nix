{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nginx;
  virtualHosts = mapAttrs (vhostName: vhostConfig:
    let
      serverName = if vhostConfig.serverName != null
        then vhostConfig.serverName
        else vhostName;
    in
    vhostConfig // {
      inherit serverName;
    } // (optionalAttrs vhostConfig.enableACME {
      sslCertificate = "/var/lib/acme/${serverName}/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/${serverName}/key.pem";
    })
  ) cfg.virtualHosts;
  enableIPv6 = config.networking.enableIPv6;

  configFile = pkgs.writeText "nginx.conf" ''
    user ${cfg.user} ${cfg.group};
    error_log stderr;
    daemon off;

    ${cfg.config}

    ${optionalString (cfg.eventsConfig != "" || cfg.config == "") ''
    events {
      ${cfg.eventsConfig}
    }
    ''}

    ${optionalString (cfg.httpConfig == "" && cfg.config == "") ''
    http {
      include ${cfg.package}/conf/mime.types;
      include ${cfg.package}/conf/fastcgi.conf;

      ${optionalString (cfg.recommendedOptimisation) ''
        # optimisation
        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
      ''}

      ssl_protocols ${cfg.sslProtocols};
      ssl_ciphers ${cfg.sslCiphers};
      ${optionalString (cfg.sslDhparam != null) "ssl_dhparam ${cfg.sslDhparam};"}

      ${optionalString (cfg.recommendedTlsSettings) ''
        ssl_session_cache shared:SSL:42m;
        ssl_session_timeout 23m;
        ssl_ecdh_curve secp384r1;
        ssl_prefer_server_ciphers on;
        ssl_stapling on;
        ssl_stapling_verify on;
      ''}

      ${optionalString (cfg.recommendedGzipSettings) ''
        gzip on;
        gzip_disable "msie6";
        gzip_proxied any;
        gzip_comp_level 9;
        gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
        gzip_vary on;
      ''}

      ${optionalString (cfg.recommendedProxySettings) ''
        proxy_set_header        Host $host;
        proxy_set_header        X-Real-IP $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto $scheme;
        proxy_set_header        X-Forwarded-Host $host;
        proxy_set_header        X-Forwarded-Server $host;
        proxy_set_header        Accept-Encoding "";

        proxy_redirect          off;
        proxy_connect_timeout   90;
        proxy_send_timeout      90;
        proxy_read_timeout      90;
        proxy_http_version      1.0;
      ''}

      client_max_body_size ${cfg.clientMaxBodySize};

      server_tokens ${if cfg.serverTokens then "on" else "off"};

      ${cfg.commonHttpConfig}

      ${vhosts}

      ${optionalString cfg.statusPage ''
        server {
          listen 80;
          ${optionalString enableIPv6 "listen [::]:80;" }

          server_name localhost;

          location /nginx_status {
            stub_status on;
            access_log off;
            allow 127.0.0.1;
            ${optionalString enableIPv6 "allow ::1;"}
            deny all;
          }
        }
      ''}

      ${cfg.appendHttpConfig}
    }''}

    ${optionalString (cfg.httpConfig != "") ''
    http {
      include ${cfg.package}/conf/mime.types;
      include ${cfg.package}/conf/fastcgi.conf;
      ${cfg.httpConfig}
    }''}

    ${cfg.appendConfig}
  '';

  vhosts = concatStringsSep "\n" (mapAttrsToList (vhostName: vhost:
      let
        ssl = vhost.enableSSL || vhost.forceSSL;
        defaultPort = if ssl then 443 else 80;

        listenString = { addr, port, ... }:
          "listen ${addr}:${toString (if port != null then port else defaultPort)} "
          + optionalString ssl "ssl http2 "
          + optionalString vhost.default "default_server"
          + ";";

        redirectListenString = { addr, ... }:
          "listen ${addr}:80 ${optionalString vhost.default "default_server"};";

        acmeLocation = ''
          location /.well-known/acme-challenge {
            ${optionalString (vhost.acmeFallbackHost != null) "try_files $uri @acme-fallback;"}
            root ${vhost.acmeRoot};
            auth_basic off;
          }
          ${optionalString (vhost.acmeFallbackHost != null) ''
            location @acme-fallback {
              auth_basic off;
              proxy_pass http://${vhost.acmeFallbackHost};
            }
          ''}
        '';

      in ''
        ${optionalString vhost.forceSSL ''
          server {
            ${concatMapStringsSep "\n" redirectListenString vhost.listen}

            server_name ${vhost.serverName} ${concatStringsSep " " vhost.serverAliases};
            ${optionalString vhost.enableACME acmeLocation}
            location / {
              return 301 https://$host$request_uri;
            }
          }
        ''}

        server {
          ${concatMapStringsSep "\n" listenString vhost.listen}
          server_name ${vhost.serverName} ${concatStringsSep " " vhost.serverAliases};
          ${optionalString vhost.enableACME acmeLocation}
          ${optionalString (vhost.root != null) "root ${vhost.root};"}
          ${optionalString (vhost.globalRedirect != null) ''
            return 301 http${optionalString ssl "s"}://${vhost.globalRedirect}$request_uri;
          ''}
          ${optionalString ssl ''
            ssl_certificate ${vhost.sslCertificate};
            ssl_certificate_key ${vhost.sslCertificateKey};
          ''}

          ${optionalString (vhost.basicAuth != {}) (mkBasicAuth vhostName vhost.basicAuth)}

          ${mkLocations vhost.locations}

          ${vhost.extraConfig}
        }
      ''
  ) virtualHosts);
  mkLocations = locations: concatStringsSep "\n" (mapAttrsToList (location: config: ''
    location ${location} {
      ${optionalString (config.proxyPass != null) "proxy_pass ${config.proxyPass};"}
      ${optionalString (config.index != null) "index ${config.index};"}
      ${optionalString (config.tryFiles != null) "try_files ${config.tryFiles};"}
      ${optionalString (config.root != null) "root ${config.root};"}
      ${optionalString (config.alias != null) "alias ${config.alias};"}
      ${config.extraConfig}
    }
  '') locations);
  mkBasicAuth = vhostName: authDef: let
    htpasswdFile = pkgs.writeText "${vhostName}.htpasswd" (
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
      enable = mkEnableOption "Nginx Web Server";

      statusPage = mkOption {
        default = false;
        type = types.bool;
        description = "
          Enable status page reachable from localhost on http://127.0.0.1/nginx_status.
        ";
      };

      recommendedTlsSettings = mkOption {
        default = false;
        type = types.bool;
        description = "
          Enable recommended TLS settings.
        ";
      };

      recommendedOptimisation = mkOption {
        default = false;
        type = types.bool;
        description = "
          Enable recommended optimisation settings.
        ";
      };

      recommendedGzipSettings = mkOption {
        default = false;
        type = types.bool;
        description = "
          Enable recommended gzip settings.
        ";
      };

      recommendedProxySettings = mkOption {
        default = false;
        type = types.bool;
        description = "
          Enable recommended proxy settings.
        ";
      };

      package = mkOption {
        default = pkgs.nginxStable;
        defaultText = "pkgs.nginxStable";
        type = types.package;
        description = "
          Nginx package to use. This defaults to the stable version. Note
          that the nginx team recommends to use the mainline version which
          available in nixpkgs as <literal>nginxMainline</literal>.
        ";
      };

      config = mkOption {
        default = "";
        description = "
          Verbatim nginx.conf configuration.
          This is mutually exclusive with the structured configuration
          via virtualHosts and the recommendedXyzSettings configuration
          options. See appendConfig for appending to the generated http block.
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

      commonHttpConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          resolver 127.0.0.1 valid=5s;

          log_format myformat '$remote_addr - $remote_user [$time_local] '
                              '"$request" $status $body_bytes_sent '
                              '"$http_referer" "$http_user_agent"';
        '';
        description = ''
          With nginx you must provide common http context definitions before
          they are used, e.g. log_format, resolver, etc. inside of server
          or location contexts. Use this attribute to set these definitions
          at the appropriate location.
        '';
      };

      httpConfig = mkOption {
        type = types.lines;
        default = "";
        description = "
          Configuration lines to be set inside the http block.
          This is mutually exclusive with the structured configuration
          via virtualHosts and the recommendedXyzSettings configuration
          options. See appendHttpConfig for appending to the generated http block.
        ";
      };

      eventsConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Configuration lines to be set inside the events block.
        '';
      };

      appendHttpConfig = mkOption {
        type = types.lines;
        default = "";
        description = "
          Configuration lines to be appended to the generated http block.
          This is mutually exclusive with using config and httpConfig for
          specifying the whole http block verbatim.
        ";
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
        description = "Show nginx version in headers and error pages.";
      };

      clientMaxBodySize = mkOption {
        type = types.string;
        default = "10m";
        description = "Set nginx global client_max_body_size.";
      };

      sslCiphers = mkOption {
        type = types.str;
        default = "EECDH+aRSA+AESGCM:EDH+aRSA:EECDH+aRSA:+AES256:+AES128:+SHA1:!CAMELLIA:!SEED:!3DES:!DES:!RC4:!eNULL";
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
        example = "/path/to/dhparams.pem";
        description = "Path to DH parameters file.";
      };

      virtualHosts = mkOption {
        type = types.attrsOf (types.submodule (import ./vhost-options.nix {
          inherit config lib;
        }));
        default = {
          localhost = {};
        };
        example = literalExample ''
          {
            "hydra.example.com" = {
              forceSSL = true;
              enableACME = true;
              locations."/" = {
                proxyPass = "http://localhost:3000";
              };
            };
          };
        '';
        description = "Declarative vhost config";
      };
    };
  };

  config = mkIf cfg.enable {
    # TODO: test user supplied config file pases syntax test

    assertions = let hostOrAliasIsNull = l: l.root == null || l.alias == null; in [
      {
        assertion = all (host: all hostOrAliasIsNull (attrValues host.locations)) (attrValues virtualHosts);
        message = "Only one of nginx root or alias can be specified on a location.";
      }
    ];

    systemd.services.nginx = {
      description = "Nginx Web Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      stopIfChanged = false;
      preStart =
        ''
        mkdir -p ${cfg.stateDir}/logs
        chmod 700 ${cfg.stateDir}
        chown -R ${cfg.user}:${cfg.group} ${cfg.stateDir}
        '';
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/nginx -c ${configFile} -p ${cfg.stateDir}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "always";
        RestartSec = "10s";
        StartLimitInterval = "1min";
      };
    };

    security.acme.certs = filterAttrs (n: v: v != {}) (
      let
        vhostsConfigs = mapAttrsToList (vhostName: vhostConfig: vhostConfig) virtualHosts;
        acmeEnabledVhosts = filter (vhostConfig: vhostConfig.enableACME) vhostsConfigs;
        acmePairs = map (vhostConfig: { name = vhostConfig.serverName; value = {
            user = cfg.user;
            group = lib.mkDefault cfg.group;
            webroot = vhostConfig.acmeRoot;
            extraDomains = genAttrs vhostConfig.serverAliases (alias: null);
            postRun = ''
              systemctl reload nginx
            '';
          }; }) acmeEnabledVhosts;
      in
        listToAttrs acmePairs
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
