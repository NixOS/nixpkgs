{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nginx;
  certs = config.security.acme.certs;
  vhostsConfigs = mapAttrsToList (vhostName: vhostConfig: vhostConfig) virtualHosts;
  acmeEnabledVhosts = filter (vhostConfig: vhostConfig.enableACME && vhostConfig.useACMEHost == null) vhostsConfigs;
  virtualHosts = mapAttrs (vhostName: vhostConfig:
    let
      serverName = if vhostConfig.serverName != null
        then vhostConfig.serverName
        else vhostName;
    in
    vhostConfig // {
      inherit serverName;
    } // (optionalAttrs vhostConfig.enableACME {
      sslCertificate = "${certs.${serverName}.directory}/fullchain.pem";
      sslCertificateKey = "${certs.${serverName}.directory}/key.pem";
      sslTrustedCertificate = "${certs.${serverName}.directory}/full.pem";
    }) // (optionalAttrs (vhostConfig.useACMEHost != null) {
      sslCertificate = "${certs.${vhostConfig.useACMEHost}.directory}/fullchain.pem";
      sslCertificateKey = "${certs.${vhostConfig.useACMEHost}.directory}/key.pem";
      sslTrustedCertificate = "${certs.${vhostConfig.useACMEHost}.directory}/fullchain.pem";
    })
  ) cfg.virtualHosts;
  enableIPv6 = config.networking.enableIPv6;

  recommendedProxyConfig = pkgs.writeText "nginx-recommended-proxy-headers.conf" ''
    proxy_set_header        Host $host;
    proxy_set_header        X-Real-IP $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_set_header        X-Forwarded-Host $host;
    proxy_set_header        X-Forwarded-Server $host;
    proxy_set_header        Accept-Encoding "";
  '';

  upstreamConfig = toString (flip mapAttrsToList cfg.upstreams (name: upstream: ''
    upstream ${name} {
      ${toString (flip mapAttrsToList upstream.servers (name: server: ''
        server ${name} ${optionalString server.backup "backup"};
      ''))}
      ${upstream.extraConfig}
    }
  ''));

  configFile = pkgs.writers.writeNginxConfig "nginx.conf" ''
    pid /run/nginx/nginx.pid;
    error_log ${cfg.logError};
    daemon off;

    ${cfg.config}

    ${optionalString (cfg.eventsConfig != "" || cfg.config == "") ''
    events {
      ${cfg.eventsConfig}
    }
    ''}

    ${optionalString (cfg.httpConfig == "" && cfg.config == "") ''
    http {
      # The mime type definitions included with nginx are very incomplete, so
      # we use a list of mime types from the mailcap package, which is also
      # used by most other Linux distributions by default.
      include ${pkgs.mailcap}/etc/nginx/mime.types;
      include ${cfg.package}/conf/fastcgi.conf;
      include ${cfg.package}/conf/uwsgi_params;

      ${optionalString (cfg.resolver.addresses != []) ''
        resolver ${toString cfg.resolver.addresses} ${optionalString (cfg.resolver.valid != "") "valid=${cfg.resolver.valid}"} ${optionalString (!cfg.resolver.ipv6) "ipv6=off"};
      ''}
      ${upstreamConfig}

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
        # Keep in sync with https://ssl-config.mozilla.org/#server=nginx&config=intermediate

        ssl_session_timeout 1d;
        ssl_session_cache shared:SSL:10m;
        # Breaks forward secrecy: https://github.com/mozilla/server-side-tls/issues/135
        ssl_session_tickets off;
        # We don't enable insecure ciphers by default, so this allows
        # clients to pick the most performant, per https://github.com/mozilla/server-side-tls/issues/260
        ssl_prefer_server_ciphers off;

        # OCSP stapling
        ssl_stapling on;
        ssl_stapling_verify on;
      ''}

      ${optionalString (cfg.recommendedGzipSettings) ''
        gzip on;
        gzip_proxied any;
        gzip_comp_level 5;
        gzip_types
          application/atom+xml
          application/javascript
          application/json
          application/xml
          application/xml+rss
          image/svg+xml
          text/css
          text/javascript
          text/plain
          text/xml;
        gzip_vary on;
      ''}

      ${optionalString (cfg.recommendedProxySettings) ''
        proxy_redirect          off;
        proxy_connect_timeout   90;
        proxy_send_timeout      90;
        proxy_read_timeout      90;
        proxy_http_version      1.0;
        include ${recommendedProxyConfig};
      ''}

      ${optionalString (cfg.mapHashBucketSize != null) ''
        map_hash_bucket_size ${toString cfg.mapHashBucketSize};
      ''}

      ${optionalString (cfg.mapHashMaxSize != null) ''
        map_hash_max_size ${toString cfg.mapHashMaxSize};
      ''}

      # $connection_upgrade is used for websocket proxying
      map $http_upgrade $connection_upgrade {
          default upgrade;
          '''      close;
      }
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
      include ${cfg.package}/conf/uwsgi_params;
      ${cfg.httpConfig}
    }''}

    ${cfg.appendConfig}
  '';

  configPath = if cfg.enableReload
    then "/etc/nginx/nginx.conf"
    else configFile;

  execCommand = "${cfg.package}/bin/nginx -c '${configPath}' -p '${cfg.stateDir}'";

  vhosts = concatStringsSep "\n" (mapAttrsToList (vhostName: vhost:
    let
        onlySSL = vhost.onlySSL || vhost.enableSSL;
        hasSSL = onlySSL || vhost.addSSL || vhost.forceSSL;

        defaultListen =
          if vhost.listen != [] then vhost.listen
          else ((optionals hasSSL (
            singleton                    { addr = "0.0.0.0"; port = 443; ssl = true; }
            ++ optional enableIPv6 { addr = "[::]";    port = 443; ssl = true; }
          )) ++ optionals (!onlySSL) (
            singleton                    { addr = "0.0.0.0"; port = 80;  ssl = false; }
            ++ optional enableIPv6 { addr = "[::]";    port = 80;  ssl = false; }
          ));

        hostListen =
          if vhost.forceSSL
            then filter (x: x.ssl) defaultListen
            else defaultListen;

        listenString = { addr, port, ssl, extraParameters ? [], ... }:
          "listen ${addr}:${toString port} "
          + optionalString ssl "ssl "
          + optionalString (ssl && vhost.http2) "http2 "
          + optionalString vhost.default "default_server "
          + optionalString (extraParameters != []) (concatStringsSep " " extraParameters)
          + ";";

        redirectListen = filter (x: !x.ssl) defaultListen;

        acmeLocation = optionalString (vhost.enableACME || vhost.useACMEHost != null) ''
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
            ${concatMapStringsSep "\n" listenString redirectListen}

            server_name ${vhost.serverName} ${concatStringsSep " " vhost.serverAliases};
            ${acmeLocation}
            location / {
              return 301 https://$host$request_uri;
            }
          }
        ''}

        server {
          ${concatMapStringsSep "\n" listenString hostListen}
          server_name ${vhost.serverName} ${concatStringsSep " " vhost.serverAliases};
          ${acmeLocation}
          ${optionalString (vhost.root != null) "root ${vhost.root};"}
          ${optionalString (vhost.globalRedirect != null) ''
            return 301 http${optionalString hasSSL "s"}://${vhost.globalRedirect}$request_uri;
          ''}
          ${optionalString hasSSL ''
            ssl_certificate ${vhost.sslCertificate};
            ssl_certificate_key ${vhost.sslCertificateKey};
          ''}
          ${optionalString (hasSSL && vhost.sslTrustedCertificate != null) ''
            ssl_trusted_certificate ${vhost.sslTrustedCertificate};
          ''}

          ${optionalString (vhost.basicAuthFile != null || vhost.basicAuth != {}) ''
            auth_basic secured;
            auth_basic_user_file ${if vhost.basicAuthFile != null then vhost.basicAuthFile else mkHtpasswd vhostName vhost.basicAuth};
          ''}

          ${mkLocations vhost.locations}

          ${vhost.extraConfig}
        }
      ''
  ) virtualHosts);
  mkLocations = locations: concatStringsSep "\n" (map (config: ''
    location ${config.location} {
      ${optionalString (config.proxyPass != null && !cfg.proxyResolveWhileRunning)
        "proxy_pass ${config.proxyPass};"
      }
      ${optionalString (config.proxyPass != null && cfg.proxyResolveWhileRunning) ''
        set $nix_proxy_target "${config.proxyPass}";
        proxy_pass $nix_proxy_target;
      ''}
      ${optionalString config.proxyWebsockets ''
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      ''}
      ${optionalString (config.index != null) "index ${config.index};"}
      ${optionalString (config.tryFiles != null) "try_files ${config.tryFiles};"}
      ${optionalString (config.root != null) "root ${config.root};"}
      ${optionalString (config.alias != null) "alias ${config.alias};"}
      ${optionalString (config.return != null) "return ${config.return};"}
      ${config.extraConfig}
      ${optionalString (config.proxyPass != null && cfg.recommendedProxySettings) "include ${recommendedProxyConfig};"}
    }
  '') (sortProperties (mapAttrsToList (k: v: v // { location = k; }) locations)));
  mkHtpasswd = vhostName: authDef: pkgs.writeText "${vhostName}.htpasswd" (
    concatStringsSep "\n" (mapAttrsToList (user: password: ''
      ${user}:{PLAIN}${password}
    '') authDef)
  );
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

      logError = mkOption {
        default = "stderr";
        description = "
          Configures logging.
          The first parameter defines a file that will store the log. The
          special value stderr selects the standard error file. Logging to
          syslog can be configured by specifying the “syslog:” prefix.
          The second parameter determines the level of logging, and can be
          one of the following: debug, info, notice, warn, error, crit,
          alert, or emerg. Log levels above are listed in the order of
          increasing severity. Setting a certain log level will cause all
          messages of the specified and more severe log levels to be logged.
          If this parameter is omitted then error is used.
        ";
      };

      preStart =  mkOption {
        type = types.lines;
        default = "";
        description = "
          Shell commands executed before the service's nginx is started.
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

      enableReload = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Reload nginx when configuration file changes (instead of restart).
          The configuration file is exposed at <filename>/etc/nginx/nginx.conf</filename>.
          See also <literal>systemd.services.*.restartIfChanged</literal>.
        '';
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
        type = types.str;
        default = "10m";
        description = "Set nginx global client_max_body_size.";
      };

      sslCiphers = mkOption {
        type = types.str;
        # Keep in sync with https://ssl-config.mozilla.org/#server=nginx&config=intermediate
        default = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
        description = "Ciphers to choose from when negotiating TLS handshakes.";
      };

      sslProtocols = mkOption {
        type = types.str;
        default = "TLSv1.2 TLSv1.3";
        example = "TLSv1 TLSv1.1 TLSv1.2 TLSv1.3";
        description = "Allowed TLS protocol versions.";
      };

      sslDhparam = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/path/to/dhparams.pem";
        description = "Path to DH parameters file.";
      };

      proxyResolveWhileRunning = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Resolves domains of proxyPass targets at runtime
          and not only at start, you have to set
          services.nginx.resolver, too.
        '';
      };

      mapHashBucketSize = mkOption {
        type = types.nullOr (types.enum [ 32 64 128 ]);
        default = null;
        description = ''
            Sets the bucket size for the map variables hash tables. Default
            value depends on the processor’s cache line size.
          '';
      };

      mapHashMaxSize = mkOption {
        type = types.nullOr types.ints.positive;
        default = null;
        description = ''
            Sets the maximum size of the map variables hash tables.
          '';
      };

      resolver = mkOption {
        type = types.submodule {
          options = {
            addresses = mkOption {
              type = types.listOf types.str;
              default = [];
              example = literalExample ''[ "[::1]" "127.0.0.1:5353" ]'';
              description = "List of resolvers to use";
            };
            valid = mkOption {
              type = types.str;
              default = "";
              example = "30s";
              description = ''
                By default, nginx caches answers using the TTL value of a response.
                An optional valid parameter allows overriding it
              '';
            };
            ipv6 = mkOption {
              type = types.bool;
              default = true;
              description = ''
                By default, nginx will look up both IPv4 and IPv6 addresses while resolving.
                If looking up of IPv6 addresses is not desired, the ipv6=off parameter can be
                specified.
              '';
            };
          };
        };
        description = ''
          Configures name servers used to resolve names of upstream servers into addresses
        '';
        default = {};
      };

      upstreams = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            servers = mkOption {
              type = types.attrsOf (types.submodule {
                options = {
                  backup = mkOption {
                    type = types.bool;
                    default = false;
                    description = ''
                      Marks the server as a backup server. It will be passed
                      requests when the primary servers are unavailable.
                    '';
                  };
                };
              });
              description = ''
                Defines the address and other parameters of the upstream servers.
              '';
              default = {};
            };
            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = ''
                These lines go to the end of the upstream verbatim.
              '';
            };
          };
        });
        description = ''
          Defines a group of servers to use as proxy target.
        '';
        default = {};
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

    warnings =
    let
      deprecatedSSL = name: config: optional config.enableSSL
      ''
        config.services.nginx.virtualHosts.<name>.enableSSL is deprecated,
        use config.services.nginx.virtualHosts.<name>.onlySSL instead.
      '';

    in flatten (mapAttrsToList deprecatedSSL virtualHosts);

    assertions =
    let
      hostOrAliasIsNull = l: l.root == null || l.alias == null;
    in [
      {
        assertion = all (host: all hostOrAliasIsNull (attrValues host.locations)) (attrValues virtualHosts);
        message = "Only one of nginx root or alias can be specified on a location.";
      }

      {
        assertion = all (conf: with conf;
          !(addSSL && (onlySSL || enableSSL)) &&
          !(forceSSL && (onlySSL || enableSSL)) &&
          !(addSSL && forceSSL)
        ) (attrValues virtualHosts);
        message = ''
          Options services.nginx.service.virtualHosts.<name>.addSSL,
          services.nginx.virtualHosts.<name>.onlySSL and services.nginx.virtualHosts.<name>.forceSSL
          are mutually exclusive.
        '';
      }

      {
        assertion = all (conf: !(conf.enableACME && conf.useACMEHost != null)) (attrValues virtualHosts);
        message = ''
          Options services.nginx.service.virtualHosts.<name>.enableACME and
          services.nginx.virtualHosts.<name>.useACMEHost are mutually exclusive.
        '';
      }
    ];

    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/logs' 0750 ${cfg.user} ${cfg.group} - -"
      "Z '${cfg.stateDir}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.nginx = {
      description = "Nginx Web Server";
      wantedBy = [ "multi-user.target" ];
      wants = concatLists (map (vhostConfig: ["acme-${vhostConfig.serverName}.service" "acme-selfsigned-${vhostConfig.serverName}.service"]) acmeEnabledVhosts);
      after = [ "network.target" ] ++ map (vhostConfig: "acme-selfsigned-${vhostConfig.serverName}.service") acmeEnabledVhosts;
      stopIfChanged = false;
      preStart = ''
        ${cfg.preStart}
        ${execCommand} -t
      '';
      serviceConfig = {
        ExecStart = execCommand;
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "always";
        RestartSec = "10s";
        StartLimitInterval = "1min";
        # User and group
        User = cfg.user;
        Group = cfg.group;
        # Runtime directory and mode
        RuntimeDirectory = "nginx";
        RuntimeDirectoryMode = "0750";
        # Capabilities
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" "CAP_SYS_RESOURCE" ];
      };
    };

    environment.etc."nginx/nginx.conf" = mkIf cfg.enableReload {
      source = configFile;
    };

    systemd.services.nginx-config-reload = mkIf cfg.enableReload {
      wants = [ "nginx.service" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configFile ];
      # commented, because can cause extra delays during activate for this config:
      #      services.nginx.virtualHosts."_".locations."/".proxyPass = "http://blabla:3000";
      # stopIfChanged = false;
      serviceConfig.Type = "oneshot";
      serviceConfig.TimeoutSec = 60;
      script = ''
        if ${pkgs.systemd}/bin/systemctl -q is-active nginx.service ; then
          ${execCommand} -t && \
            ${pkgs.systemd}/bin/systemctl reload nginx.service
        fi
      '';
      serviceConfig.RemainAfterExit = true;
    };

    security.acme.certs = filterAttrs (n: v: v != {}) (
      let
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

    users.users = optionalAttrs (cfg.user == "nginx") {
      nginx = {
        group = cfg.group;
        uid = config.ids.uids.nginx;
      };
    };

    users.groups = optionalAttrs (cfg.group == "nginx") {
      nginx.gid = config.ids.gids.nginx;
    };

  };
}
