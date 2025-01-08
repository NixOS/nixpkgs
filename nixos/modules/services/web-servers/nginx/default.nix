{ config, lib, pkgs, ... }:

let
  cfg = config.services.nginx;
  inherit (config.security.acme) certs;
  vhostsConfigs = lib.mapAttrsToList (vhostName: vhostConfig: vhostConfig) virtualHosts;
  acmeEnabledVhosts = lib.filter (vhostConfig: vhostConfig.enableACME || vhostConfig.useACMEHost != null) vhostsConfigs;
  vhostCertNames = lib.unique (map (hostOpts: hostOpts.certName) acmeEnabledVhosts);
  dependentCertNames = lib.filter (cert: certs.${cert}.dnsProvider == null) vhostCertNames; # those that might depend on the HTTP server
  independentCertNames = lib.filter (cert: certs.${cert}.dnsProvider != null) vhostCertNames; # those that don't depend on the HTTP server
  virtualHosts = lib.mapAttrs (vhostName: vhostConfig:
    let
      serverName = if vhostConfig.serverName != null
        then vhostConfig.serverName
        else vhostName;
      certName = if vhostConfig.useACMEHost != null
        then vhostConfig.useACMEHost
        else serverName;
    in
    vhostConfig // {
      inherit serverName certName;
    } // (lib.optionalAttrs (vhostConfig.enableACME || vhostConfig.useACMEHost != null) {
      sslCertificate = "${certs.${certName}.directory}/fullchain.pem";
      sslCertificateKey = "${certs.${certName}.directory}/key.pem";
      sslTrustedCertificate = if vhostConfig.sslTrustedCertificate != null
                              then vhostConfig.sslTrustedCertificate
                              else "${certs.${certName}.directory}/chain.pem";
    })
  ) cfg.virtualHosts;
  inherit (config.networking) enableIPv6;

  # Mime.types values are taken from brotli sample configuration - https://github.com/google/ngx_brotli
  # and Nginx Server Configs - https://github.com/h5bp/server-configs-nginx
  # "text/html" is implicitly included in {brotli,gzip,zstd}_types
  compressMimeTypes = [
    "application/atom+xml"
    "application/geo+json"
    "application/javascript" # Deprecated by IETF RFC 9239, but still widely used
    "application/json"
    "application/ld+json"
    "application/manifest+json"
    "application/rdf+xml"
    "application/vnd.ms-fontobject"
    "application/wasm"
    "application/x-rss+xml"
    "application/x-web-app-manifest+json"
    "application/xhtml+xml"
    "application/xliff+xml"
    "application/xml"
    "font/collection"
    "font/otf"
    "font/ttf"
    "image/bmp"
    "image/svg+xml"
    "image/vnd.microsoft.icon"
    "text/cache-manifest"
    "text/calendar"
    "text/css"
    "text/csv"
    "text/javascript"
    "text/markdown"
    "text/plain"
    "text/vcard"
    "text/vnd.rim.location.xloc"
    "text/vtt"
    "text/x-component"
    "text/xml"
  ];

  defaultFastcgiParams = {
    SCRIPT_FILENAME   = "$document_root$fastcgi_script_name";
    QUERY_STRING      = "$query_string";
    REQUEST_METHOD    = "$request_method";
    CONTENT_TYPE      = "$content_type";
    CONTENT_LENGTH    = "$content_length";

    SCRIPT_NAME       = "$fastcgi_script_name";
    REQUEST_URI       = "$request_uri";
    DOCUMENT_URI      = "$document_uri";
    DOCUMENT_ROOT     = "$document_root";
    SERVER_PROTOCOL   = "$server_protocol";
    REQUEST_SCHEME    = "$scheme";
    HTTPS             = "$https if_not_empty";

    GATEWAY_INTERFACE = "CGI/1.1";
    SERVER_SOFTWARE   = "nginx/$nginx_version";

    REMOTE_ADDR       = "$remote_addr";
    REMOTE_PORT       = "$remote_port";
    SERVER_ADDR       = "$server_addr";
    SERVER_PORT       = "$server_port";
    SERVER_NAME       = "$server_name";

    REDIRECT_STATUS   = "200";
  };

  recommendedProxyConfig = pkgs.writeText "nginx-recommended-proxy-headers.conf" ''
    proxy_set_header        Host $host;
    proxy_set_header        X-Real-IP $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_set_header        X-Forwarded-Host $host;
    proxy_set_header        X-Forwarded-Server $host;
  '';

  proxyCachePathConfig = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: proxyCachePath: ''
    proxy_cache_path ${lib.concatStringsSep " " [
      "/var/cache/nginx/${name}"
      "keys_zone=${proxyCachePath.keysZoneName}:${proxyCachePath.keysZoneSize}"
      "levels=${proxyCachePath.levels}"
      "use_temp_path=${if proxyCachePath.useTempPath then "on" else "off"}"
      "inactive=${proxyCachePath.inactive}"
      "max_size=${proxyCachePath.maxSize}"
    ]};
  '') (lib.filterAttrs (name: conf: conf.enable) cfg.proxyCachePath));

  toUpstreamParameter = key: value:
    if builtins.isBool value
    then lib.optionalString value key
    else "${key}=${toString value}";

  upstreamConfig = toString (lib.flip lib.mapAttrsToList cfg.upstreams (name: upstream: ''
    upstream ${name} {
      ${toString (lib.flip lib.mapAttrsToList upstream.servers (name: server: ''
        server ${name} ${lib.concatStringsSep " " (lib.mapAttrsToList toUpstreamParameter server)};
      ''))}
      ${upstream.extraConfig}
    }
  ''));

  commonHttpConfig = ''
      # Load mime types and configure maximum size of the types hash tables.
      include ${cfg.defaultMimeTypes};
      types_hash_max_size ${toString cfg.typesHashMaxSize};

      include ${cfg.package}/conf/fastcgi.conf;
      include ${cfg.package}/conf/uwsgi_params;

      default_type application/octet-stream;
  '';

  configFile = (
      if cfg.validateConfigFile
      then pkgs.writers.writeNginxConfig
      else pkgs.writeText
    ) "nginx.conf" ''
    pid /run/nginx/nginx.pid;
    error_log ${cfg.logError};
    daemon off;

    ${lib.optionalString cfg.enableQuicBPF ''
      quic_bpf on;
    ''}

    ${cfg.config}

    ${lib.optionalString (cfg.eventsConfig != "" || cfg.config == "") ''
    events {
      ${cfg.eventsConfig}
    }
    ''}

    ${lib.optionalString (cfg.httpConfig == "" && cfg.config == "") ''
    http {
      ${commonHttpConfig}

      ${lib.optionalString (cfg.resolver.addresses != []) ''
        resolver ${toString cfg.resolver.addresses} ${lib.optionalString (cfg.resolver.valid != "") "valid=${cfg.resolver.valid}"} ${lib.optionalString (!cfg.resolver.ipv4) "ipv4=off"} ${lib.optionalString (!cfg.resolver.ipv6) "ipv6=off"};
      ''}
      ${upstreamConfig}

      ${lib.optionalString cfg.recommendedOptimisation ''
        # optimisation
        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
      ''}

      ssl_protocols ${cfg.sslProtocols};
      ${lib.optionalString (cfg.sslCiphers != null) "ssl_ciphers ${cfg.sslCiphers};"}
      ${lib.optionalString (cfg.sslDhparam != null) "ssl_dhparam ${cfg.sslDhparam};"}

      ${lib.optionalString cfg.recommendedTlsSettings ''
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

      ${lib.optionalString cfg.recommendedBrotliSettings ''
        brotli on;
        brotli_static on;
        brotli_comp_level 5;
        brotli_window 512k;
        brotli_min_length 256;
        brotli_types ${lib.concatStringsSep " " compressMimeTypes};
      ''}

      ${lib.optionalString cfg.recommendedGzipSettings
        # https://docs.nginx.com/nginx/admin-guide/web-server/compression/
      ''
        gzip on;
        gzip_static on;
        gzip_vary on;
        gzip_comp_level 5;
        gzip_min_length 256;
        gzip_proxied expired no-cache no-store private auth;
        gzip_types ${lib.concatStringsSep " " compressMimeTypes};
      ''}

      ${lib.optionalString cfg.recommendedZstdSettings ''
        zstd on;
        zstd_comp_level 9;
        zstd_min_length 256;
        zstd_static on;
        zstd_types ${lib.concatStringsSep " " compressMimeTypes};
      ''}

      ${lib.optionalString cfg.recommendedProxySettings ''
        proxy_redirect          off;
        proxy_connect_timeout   ${cfg.proxyTimeout};
        proxy_send_timeout      ${cfg.proxyTimeout};
        proxy_read_timeout      ${cfg.proxyTimeout};
        proxy_http_version      1.1;
        # don't let clients close the keep-alive connection to upstream. See the nginx blog for details:
        # https://www.nginx.com/blog/avoiding-top-10-nginx-configuration-mistakes/#no-keepalives
        proxy_set_header        "Connection" "";
        include ${recommendedProxyConfig};
      ''}

      ${lib.optionalString (cfg.mapHashBucketSize != null) ''
        map_hash_bucket_size ${toString cfg.mapHashBucketSize};
      ''}

      ${lib.optionalString (cfg.mapHashMaxSize != null) ''
        map_hash_max_size ${toString cfg.mapHashMaxSize};
      ''}

      ${lib.optionalString (cfg.serverNamesHashBucketSize != null) ''
        server_names_hash_bucket_size ${toString cfg.serverNamesHashBucketSize};
      ''}

      ${lib.optionalString (cfg.serverNamesHashMaxSize != null) ''
        server_names_hash_max_size ${toString cfg.serverNamesHashMaxSize};
      ''}

      # $connection_upgrade is used for websocket proxying
      map $http_upgrade $connection_upgrade {
          default upgrade;
          '''      close;
      }
      client_max_body_size ${cfg.clientMaxBodySize};

      server_tokens ${if cfg.serverTokens then "on" else "off"};

      ${cfg.commonHttpConfig}

      ${proxyCachePathConfig}

      ${vhosts}

      ${cfg.appendHttpConfig}
    }''}

    ${lib.optionalString (cfg.httpConfig != "") ''
    http {
      ${commonHttpConfig}
      ${cfg.httpConfig}
    }''}

    ${lib.optionalString (cfg.streamConfig != "") ''
    stream {
      ${cfg.streamConfig}
    }
    ''}

    ${cfg.appendConfig}
  '';

  configPath = if cfg.enableReload
    then "/etc/nginx/nginx.conf"
    else configFile;

  execCommand = "${cfg.package}/bin/nginx -c '${configPath}'";

  vhosts = lib.concatStringsSep "\n" (lib.mapAttrsToList (vhostName: vhost:
    let
        onlySSL = vhost.onlySSL || vhost.enableSSL;
        hasSSL = onlySSL || vhost.addSSL || vhost.forceSSL;

        # First evaluation of defaultListen based on a set of listen lines.
        mkDefaultListenVhost = listenLines:
          # If this vhost has SSL or is a SSL rejection host.
          # We enable a TLS variant for lines without explicit ssl or ssl = true.
          lib.optionals (hasSSL || vhost.rejectSSL)
            (map (listen: { port = cfg.defaultSSLListenPort; ssl = true; } // listen)
            (lib.filter (listen: !(listen ? ssl) || listen.ssl) listenLines))
          # If this vhost is supposed to serve HTTP
          # We provide listen lines for those without explicit ssl or ssl = false.
          ++ lib.optionals (!onlySSL)
            (map (listen: { port = cfg.defaultHTTPListenPort; ssl = false; } // listen)
            (lib.filter (listen: !(listen ? ssl) || !listen.ssl) listenLines));

        defaultListen =
          if vhost.listen != [] then vhost.listen
          else
          if cfg.defaultListen != [] then mkDefaultListenVhost
            # Cleanup nulls which will mess up with //.
            # TODO: is there a better way to achieve this? i.e. mergeButIgnoreNullPlease?
            (map (listenLine: lib.filterAttrs (_: v: (v != null)) listenLine) cfg.defaultListen)
          else
            let addrs = if vhost.listenAddresses != [] then vhost.listenAddresses else cfg.defaultListenAddresses;
            in mkDefaultListenVhost (map (addr: { inherit addr; }) addrs);


        hostListen =
          if vhost.forceSSL
            then lib.filter (x: x.ssl) defaultListen
            else defaultListen;

        listenString = { addr, port, ssl, proxyProtocol ? false, extraParameters ? [], ... }:
          # UDP listener for QUIC transport protocol.
          (lib.optionalString (ssl && vhost.quic) ("
            listen ${addr}${lib.optionalString (port != null) ":${toString port}"} quic "
          + lib.optionalString vhost.default "default_server "
          + lib.optionalString vhost.reuseport "reuseport "
          + lib.optionalString (extraParameters != []) (lib.concatStringsSep " "
            (let inCompatibleParameters = [ "accept_filter" "backlog" "deferred" "fastopen" "http2" "proxy_protocol" "so_keepalive" "ssl" ];
                isCompatibleParameter = param: !(lib.any (p: lib.hasPrefix p param) inCompatibleParameters);
            in lib.filter isCompatibleParameter extraParameters))
          + ";"))
          + "
            listen ${addr}${lib.optionalString (port != null) ":${toString port}"} "
          + lib.optionalString (ssl && vhost.http2 && oldHTTP2) "http2 "
          + lib.optionalString ssl "ssl "
          + lib.optionalString vhost.default "default_server "
          + lib.optionalString vhost.reuseport "reuseport "
          + lib.optionalString proxyProtocol "proxy_protocol "
          + lib.optionalString (extraParameters != []) (lib.concatStringsSep " " extraParameters)
          + ";";

        redirectListen = lib.filter (x: !x.ssl) defaultListen;

        # The acme-challenge location doesn't need to be added if we are not using any automated
        # certificate provisioning and can also be omitted when we use a certificate obtained via a DNS-01 challenge
        acmeName = if vhost.useACMEHost != null then vhost.useACMEHost else vhost.serverName;
        acmeLocation = lib.optionalString ((vhost.enableACME || vhost.useACMEHost != null) && config.security.acme.certs.${acmeName}.dnsProvider == null)
          # Rule for legitimate ACME Challenge requests (like /.well-known/acme-challenge/xxxxxxxxx)
          # We use ^~ here, so that we don't check any regexes (which could
          # otherwise easily override this intended match accidentally).
        ''
          location ^~ /.well-known/acme-challenge/ {
            ${lib.optionalString (vhost.acmeFallbackHost != null) "try_files $uri @acme-fallback;"}
            ${lib.optionalString (vhost.acmeRoot != null) "root ${vhost.acmeRoot};"}
            auth_basic off;
            auth_request off;
          }
          ${lib.optionalString (vhost.acmeFallbackHost != null) ''
            location @acme-fallback {
              auth_basic off;
              auth_request off;
              proxy_pass http://${vhost.acmeFallbackHost};
            }
          ''}
        '';

      in ''
        ${lib.optionalString vhost.forceSSL ''
          server {
            ${lib.concatMapStringsSep "\n" listenString redirectListen}

            server_name ${vhost.serverName} ${lib.concatStringsSep " " vhost.serverAliases};

            location / {
              return ${toString vhost.redirectCode} https://$host$request_uri;
            }
            ${acmeLocation}
          }
        ''}

        server {
          ${lib.concatMapStringsSep "\n" listenString hostListen}
          server_name ${vhost.serverName} ${lib.concatStringsSep " " vhost.serverAliases};
          ${lib.optionalString (hasSSL && vhost.http2 && !oldHTTP2) ''
            http2 on;
          ''}
          ${lib.optionalString (hasSSL && vhost.quic) ''
            http3 ${if vhost.http3 then "on" else "off"};
            http3_hq ${if vhost.http3_hq then "on" else "off"};
          ''}
          ${lib.optionalString hasSSL ''
            ssl_certificate ${vhost.sslCertificate};
            ssl_certificate_key ${vhost.sslCertificateKey};
          ''}
          ${lib.optionalString (hasSSL && vhost.sslTrustedCertificate != null) ''
            ssl_trusted_certificate ${vhost.sslTrustedCertificate};
          ''}
          ${lib.optionalString vhost.rejectSSL ''
            ssl_reject_handshake on;
          ''}
          ${lib.optionalString (hasSSL && vhost.kTLS) ''
            ssl_conf_command Options KTLS;
          ''}

          ${mkBasicAuth vhostName vhost}

          ${lib.optionalString (vhost.root != null) "root ${vhost.root};"}

          ${lib.optionalString (vhost.globalRedirect != null) ''
            location / {
              return ${toString vhost.redirectCode} http${lib.optionalString hasSSL "s"}://${vhost.globalRedirect}$request_uri;
            }
          ''}
          ${acmeLocation}
          ${mkLocations vhost.locations}

          ${vhost.extraConfig}
        }
      ''
  ) virtualHosts);
  mkLocations = locations: lib.concatStringsSep "\n" (map (config: ''
    location ${config.location} {
      ${lib.optionalString (config.proxyPass != null && !cfg.proxyResolveWhileRunning)
        "proxy_pass ${config.proxyPass};"
      }
      ${lib.optionalString (config.proxyPass != null && cfg.proxyResolveWhileRunning) ''
        set $nix_proxy_target "${config.proxyPass}";
        proxy_pass $nix_proxy_target;
      ''}
      ${lib.optionalString config.proxyWebsockets ''
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      ''}
      ${lib.concatStringsSep "\n"
        (lib.mapAttrsToList (n: v: ''fastcgi_param ${n} "${v}";'')
          (lib.optionalAttrs (config.fastcgiParams != {})
            (defaultFastcgiParams // config.fastcgiParams)))}
      ${lib.optionalString (config.index != null) "index ${config.index};"}
      ${lib.optionalString (config.tryFiles != null) "try_files ${config.tryFiles};"}
      ${lib.optionalString (config.root != null) "root ${config.root};"}
      ${lib.optionalString (config.alias != null) "alias ${config.alias};"}
      ${lib.optionalString (config.return != null) "return ${toString config.return};"}
      ${config.extraConfig}
      ${lib.optionalString (config.proxyPass != null && config.recommendedProxySettings) "include ${recommendedProxyConfig};"}
      ${mkBasicAuth "sublocation" config}
    }
  '') (lib.sortProperties (lib.mapAttrsToList (k: v: v // { location = k; }) locations)));

  mkBasicAuth = name: zone: lib.optionalString (zone.basicAuthFile != null || zone.basicAuth != {}) (let
    auth_file = if zone.basicAuthFile != null
      then zone.basicAuthFile
      else mkHtpasswd name zone.basicAuth;
  in ''
    auth_basic secured;
    auth_basic_user_file ${auth_file};
  '');
  mkHtpasswd = name: authDef: pkgs.writeText "${name}.htpasswd" (
    lib.concatStringsSep "\n" (lib.mapAttrsToList (user: password: ''
      ${user}:{PLAIN}${password}
    '') authDef)
  );

  mkCertOwnershipAssertion = import ../../../security/acme/mk-cert-ownership-assertion.nix lib;

  oldHTTP2 = (lib.versionOlder cfg.package.version "1.25.1" && !(cfg.package.pname == "angie" || cfg.package.pname == "angieQuic"));
in

{
  options = {
    services.nginx = {
      enable = lib.mkEnableOption "Nginx Web Server";

      statusPage = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable status page reachable from localhost on http://127.0.0.1/nginx_status.
        '';
      };

      recommendedTlsSettings = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable recommended TLS settings.
        '';
      };

      recommendedOptimisation = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable recommended optimisation settings.
        '';
      };

      recommendedBrotliSettings = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable recommended brotli settings.
          Learn more about compression in Brotli format [here](https://github.com/google/ngx_brotli/).

          This adds `pkgs.nginxModules.brotli` to `services.nginx.additionalModules`.
        '';
      };

      recommendedGzipSettings = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable recommended gzip settings.
          Learn more about compression in Gzip format [here](https://docs.nginx.com/nginx/admin-guide/web-server/compression/).
        '';
      };

      recommendedZstdSettings = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable recommended zstd settings.
          Learn more about compression in Zstd format [here](https://github.com/tokers/zstd-nginx-module).

          This adds `pkgs.nginxModules.zstd` to `services.nginx.additionalModules`.
        '';
      };

      recommendedProxySettings = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable recommended proxy settings if a vhost does not specify the option manually.
        '';
      };

      proxyTimeout = lib.mkOption {
        type = lib.types.str;
        default = "60s";
        example = "20s";
        description = ''
          Change the proxy related timeouts in recommendedProxySettings.
        '';
      };

      defaultListen = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule {
          options = {
            addr = lib.mkOption {
              type = lib.str;
              description = "IP address.";
            };
            port = lib.mkOption {
              type = lib.nullOr lib.port;
              description = "Port number.";
              default = null;
            };
            ssl  = lib.mkOption {
              type = lib.nullOr lib.bool;
              default = null;
              description = "Enable SSL.";
            };
            proxyProtocol = lib.mkOption {
              type = lib.bool;
              description = "Enable PROXY protocol.";
              default = false;
            };
            extraParameters = lib.mkOption {
              type = lib.listOf lib.str;
              description = "Extra parameters of this listen directive.";
              default = [ ];
              example = [ "backlog=1024" "deferred" ];
            };
          };
        });
        default = [];
        example = lib.literalExpression ''
          [
            { addr = "10.0.0.12"; proxyProtocol = true; ssl = true; }
            { addr = "0.0.0.0"; }
            { addr = "[::0]"; }
          ]
        '';
        description = ''
          If vhosts do not specify listen, use these addresses by default.
          This option takes precedence over {option}`defaultListenAddresses` and
          other listen-related defaults options.
        '';
      };

      defaultListenAddresses = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "0.0.0.0" ] ++ lib.optional enableIPv6 "[::0]";
        defaultText = lib.literalExpression ''[ "0.0.0.0" ] ++ lib.optional config.networking.enableIPv6 "[::0]"'';
        example = lib.literalExpression ''[ "10.0.0.12" "[2002:a00:1::]" ]'';
        description = ''
          If vhosts do not specify listenAddresses, use these addresses by default.
          This is akin to writing `defaultListen = [ { addr = "0.0.0.0" } ]`.
        '';
      };

      defaultHTTPListenPort = lib.mkOption {
        type = lib.types.port;
        default = 80;
        example = 8080;
        description = ''
          If vhosts do not specify listen.port, use these ports for HTTP by default.
        '';
      };

      defaultSSLListenPort = lib.mkOption {
        type = lib.types.port;
        default = 443;
        example = 8443;
        description = ''
          If vhosts do not specify listen.port, use these ports for SSL by default.
        '';
      };

      defaultMimeTypes = lib.mkOption {
        type = lib.types.path;
        default = "${pkgs.mailcap}/etc/nginx/mime.types";
        defaultText = lib.literalExpression "$''{pkgs.mailcap}/etc/nginx/mime.types";
        example = lib.literalExpression "$''{pkgs.nginx}/conf/mime.types";
        description = ''
          Default MIME types for NGINX, as MIME types definitions from NGINX are very incomplete,
          we use by default the ones bundled in the mailcap package, used by most of the other
          Linux distributions.
        '';
      };

      package = lib.mkOption {
        default = pkgs.nginxStable;
        defaultText = lib.literalExpression "pkgs.nginxStable";
        type = lib.types.package;
        apply = p: p.override {
          modules = lib.unique (p.modules ++ cfg.additionalModules);
        };
        description = ''
          Nginx package to use. This defaults to the stable version. Note
          that the nginx team recommends to use the mainline version which
          available in nixpkgs as `nginxMainline`.
          Supported Nginx forks include `angie`, `openresty` and `tengine`.
          For HTTP/3 support use `nginxQuic` or `angieQuic`.
        '';
      };

      additionalModules = lib.mkOption {
        default = [];
        type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
        example = lib.literalExpression "[ pkgs.nginxModules.echo ]";
        description = ''
          Additional [third-party nginx modules](https://www.nginx.com/resources/wiki/modules/)
          to install. Packaged modules are available in `pkgs.nginxModules`.
        '';
      };

      logError = lib.mkOption {
        default = "stderr";
        type = lib.types.str;
        description = ''
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
        '';
      };

      preStart =  lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Shell commands executed before the service's nginx is started.
        '';
      };

      config = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Verbatim {file}`nginx.conf` configuration.
          This is mutually exclusive to any other config option for
          {file}`nginx.conf` except for
          - [](#opt-services.nginx.appendConfig)
          - [](#opt-services.nginx.httpConfig)
          - [](#opt-services.nginx.logError)

          If additional verbatim config in addition to other options is needed,
          [](#opt-services.nginx.appendConfig) should be used instead.
        '';
      };

      appendConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Configuration lines appended to the generated Nginx
          configuration file. Commonly used by different modules
          providing http snippets. {option}`appendConfig`
          can be specified more than once and its value will be
          concatenated (contrary to {option}`config` which
          can be set only once).
        '';
      };

      commonHttpConfig = lib.mkOption {
        type = lib.types.lines;
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

      httpConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Configuration lines to be set inside the http block.
          This is mutually exclusive with the structured configuration
          via virtualHosts and the recommendedXyzSettings configuration
          options. See appendHttpConfig for appending to the generated http block.
        '';
      };

      streamConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = ''
          server {
            listen 127.0.0.1:53 udp reuseport;
            proxy_timeout 20s;
            proxy_pass 192.168.0.1:53535;
          }
        '';
        description = ''
          Configuration lines to be set inside the stream block.
        '';
      };

      eventsConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Configuration lines to be set inside the events block.
        '';
      };

      appendHttpConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Configuration lines to be appended to the generated http block.
          This is mutually exclusive with using config and httpConfig for
          specifying the whole http block verbatim.
        '';
      };

      enableReload = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Reload nginx when configuration file changes (instead of restart).
          The configuration file is exposed at {file}`/etc/nginx/nginx.conf`.
          See also `systemd.services.*.restartIfChanged`.
        '';
      };

      enableQuicBPF = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enables routing of QUIC packets using eBPF. When enabled, this allows
          to support QUIC connection migration. The directive is only supported
          on Linux 5.7+.
          Note that enabling this option will make nginx run with extended
          capabilities that are usually limited to processes running as root
          namely `CAP_SYS_ADMIN` and `CAP_NET_ADMIN`.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "nginx";
        description = "User account under which nginx runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "nginx";
        description = "Group account under which nginx runs.";
      };

      serverTokens = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Show nginx version in headers and error pages.";
      };

      clientMaxBodySize = lib.mkOption {
        type = lib.types.str;
        default = "10m";
        description = "Set nginx global client_max_body_size.";
      };

      sslCiphers = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        # Keep in sync with https://ssl-config.mozilla.org/#server=nginx&config=intermediate
        default = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305";
        description = "Ciphers to choose from when negotiating TLS handshakes.";
      };

      sslProtocols = lib.mkOption {
        type = lib.types.str;
        default = "TLSv1.2 TLSv1.3";
        example = "TLSv1 TLSv1.1 TLSv1.2 TLSv1.3";
        description = "Allowed TLS protocol versions.";
      };

      sslDhparam = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/path/to/dhparams.pem";
        description = "Path to DH parameters file.";
      };

      proxyResolveWhileRunning = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Resolves domains of proxyPass targets at runtime and not only at startup.
          This can be used as a workaround if nginx fails to start because of not-yet-working DNS.

          :::{.warn}
          `services.nginx.resolver` must be set for this option to work.
          :::
        '';
      };

      mapHashBucketSize = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ 32 64 128 ]);
        default = null;
        description = ''
            Sets the bucket size for the map variables hash tables. Default
            value depends on the processor’s cache line size.
          '';
      };

      mapHashMaxSize = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.positive;
        default = null;
        description = ''
            Sets the maximum size of the map variables hash tables.
          '';
      };

      serverNamesHashBucketSize = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.positive;
        default = null;
        description = ''
            Sets the bucket size for the server names hash tables. Default
            value depends on the processor’s cache line size.
          '';
      };

      serverNamesHashMaxSize = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.positive;
        default = null;
        description = ''
            Sets the maximum size of the server names hash tables.
          '';
      };

      typesHashMaxSize = lib.mkOption {
        type = lib.types.ints.positive;
        default = if cfg.defaultMimeTypes == "${pkgs.mailcap}/etc/nginx/mime.types" then 2688 else 1024;
        defaultText = lib.literalExpression ''if config.services.nginx.defaultMimeTypes == "''${pkgs.mailcap}/etc/nginx/mime.types" then 2688 else 1024'';
        description = ''
          Sets the maximum size of the types hash tables (`types_hash_max_size`).
          It is recommended that the minimum size possible size is used.
          If {option}`recommendedOptimisation` is disabled, nginx would otherwise
          fail to start since the mailmap `mime.types` database has more entries
          than the nginx default value 1024.
        '';
      };

      proxyCachePath = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule ({ ... }: {
          options = {
            enable = lib.mkEnableOption "this proxy cache path entry";

            keysZoneName = lib.mkOption {
              type = lib.types.str;
              default = "cache";
              example = "my_cache";
              description = "Set name to shared memory zone.";
            };

            keysZoneSize = lib.mkOption {
              type = lib.types.str;
              default = "10m";
              example = "32m";
              description = "Set size to shared memory zone.";
            };

            levels = lib.mkOption {
              type = lib.types.str;
              default = "1:2";
              example = "1:2:2";
              description = ''
                The levels parameter defines structure of subdirectories in cache: from
                1 to 3, each level accepts values 1 or 2. Сan be used any combination of
                1 and 2 in these formats: x, x:x and x:x:x.
              '';
            };

            useTempPath = lib.mkOption {
              type = lib.types.bool;
              default = false;
              example = true;
              description = ''
                Nginx first writes files that are destined for the cache to a temporary
                storage area, and the use_temp_path=off directive instructs Nginx to
                write them to the same directories where they will be cached. Recommended
                that you set this parameter to off to avoid unnecessary copying of data
                between file systems.
              '';
            };

            inactive = lib.mkOption {
              type = lib.types.str;
              default = "10m";
              example = "1d";
              description = ''
                Cached data that has not been accessed for the time specified by
                the inactive parameter is removed from the cache, regardless of
                its freshness.
              '';
            };

            maxSize = lib.mkOption {
              type = lib.types.str;
              default = "1g";
              example = "2048m";
              description = "Set maximum cache size";
            };
          };
        }));
        default = {};
        description = ''
          Configure a proxy cache path entry.
          See <https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path> for documentation.
        '';
      };

      resolver = lib.mkOption {
        type = lib.types.submodule {
          options = {
            addresses = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [];
              example = lib.literalExpression ''[ "[::1]" "127.0.0.1:5353" ]'';
              description = "List of resolvers to use";
            };
            valid = lib.mkOption {
              type = lib.types.str;
              default = "";
              example = "30s";
              description = ''
                By default, nginx caches answers using the TTL value of a response.
                An lib.optional valid parameter allows overriding it
              '';
            };
            ipv4 = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                By default, nginx will look up both IPv4 and IPv6 addresses while resolving.
                If looking up of IPv4 addresses is not desired, the ipv4=off parameter can be
                specified.
              '';
            };
            ipv6 = lib.mkOption {
              type = lib.types.bool;
              default = config.networking.enableIPv6;
              defaultText = lib.literalExpression "config.networking.enableIPv6";
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

      upstreams = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            servers = lib.mkOption {
              type = lib.types.attrsOf (lib.types.submodule {
                freeformType = lib.types.attrsOf (lib.types.oneOf [ lib.types.bool lib.types.int lib.types.str ]);
                options = {
                  backup = lib.mkOption {
                    type = lib.types.bool;
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
                See [the documentation](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server)
                for the available parameters.
              '';
              default = {};
              example = lib.literalMD "see [](#opt-services.nginx.upstreams)";
            };
            extraConfig = lib.mkOption {
              type = lib.types.lines;
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
        example = {
          "backend" = {
            servers = {
              "backend1.example.com:8080" = { weight = 5; };
              "backend2.example.com" = { max_fails = 3; fail_timeout = "30s"; };
              "backend3.example.com" = {};
              "backup1.example.com" = { backup = true; };
              "backup2.example.com" = { backup = true; };
            };
            extraConfig = ''
              keepalive 16;
            '';
          };
          "memcached" = {
            servers."unix:/run/memcached/memcached.sock" = {};
          };
        };
      };

      virtualHosts = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule (import ./vhost-options.nix {
          inherit config lib;
        }));
        default = {
          localhost = {};
        };
        example = lib.literalExpression ''
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
      validateConfigFile = lib.mkEnableOption "validating configuration with pkgs.writeNginxConfig" // {
        default = true;
      };
    };
  };

  imports = [
    (lib.mkRemovedOptionModule [ "services" "nginx" "stateDir" ] ''
      The Nginx log directory has been moved to /var/log/nginx, the cache directory
      to /var/cache/nginx. The option services.nginx.stateDir has been removed.
    '')
    (lib.mkRenamedOptionModule [ "services" "nginx" "proxyCache" "inactive" ] [ "services" "nginx" "proxyCachePath" "" "inactive" ])
    (lib.mkRenamedOptionModule [ "services" "nginx" "proxyCache" "useTempPath" ] [ "services" "nginx" "proxyCachePath" "" "useTempPath" ])
    (lib.mkRenamedOptionModule [ "services" "nginx" "proxyCache" "levels" ] [ "services" "nginx" "proxyCachePath" "" "levels" ])
    (lib.mkRenamedOptionModule [ "services" "nginx" "proxyCache" "keysZoneSize" ] [ "services" "nginx" "proxyCachePath" "" "keysZoneSize" ])
    (lib.mkRenamedOptionModule [ "services" "nginx" "proxyCache" "keysZoneName" ] [ "services" "nginx" "proxyCachePath" "" "keysZoneName" ])
    (lib.mkRenamedOptionModule [ "services" "nginx" "proxyCache" "enable" ] [ "services" "nginx" "proxyCachePath" "" "enable" ])
  ];

  config = lib.mkIf cfg.enable {
    warnings =
    let
      deprecatedSSL = name: config: lib.optional config.enableSSL
      ''
        config.services.nginx.virtualHosts.<name>.enableSSL is deprecated,
        use config.services.nginx.virtualHosts.<name>.onlySSL instead.
      '';

    in lib.flatten (lib.mapAttrsToList deprecatedSSL virtualHosts);

    assertions =
    let
      hostOrAliasIsNull = l: l.root == null || l.alias == null;
    in [
      {
        assertion = lib.all (host: lib.all hostOrAliasIsNull (lib.attrValues host.locations)) (lib.attrValues virtualHosts);
        message = "Only one of nginx root or alias can be specified on a location.";
      }

      {
        assertion = lib.all (host: with host;
          count id [ addSSL (onlySSL || enableSSL) forceSSL rejectSSL ] <= 1
        ) (lib.attrValues virtualHosts);
        message = ''
          Options services.nginx.service.virtualHosts.<name>.addSSL,
          services.nginx.virtualHosts.<name>.onlySSL,
          services.nginx.virtualHosts.<name>.forceSSL and
          services.nginx.virtualHosts.<name>.rejectSSL are mutually exclusive.
        '';
      }

      {
        assertion = lib.all (host: !(host.enableACME && host.useACMEHost != null)) (lib.attrValues virtualHosts);
        message = ''
          Options services.nginx.service.virtualHosts.<name>.enableACME and
          services.nginx.virtualHosts.<name>.useACMEHost are mutually exclusive.
        '';
      }

      {
        assertion = cfg.package.pname != "nginxQuic" && cfg.package.pname != "angieQuic" -> !(cfg.enableQuicBPF);
        message = ''
          services.nginx.enableQuicBPF requires using nginxQuic package,
          which can be achieved by setting `services.nginx.package = pkgs.nginxQuic;` or
          `services.nginx.package = pkgs.angieQuic;`.
        '';
      }

      {
        assertion = cfg.package.pname != "nginxQuic" && cfg.package.pname != "angieQuic" -> lib.all (host: !host.quic) (lib.attrValues virtualHosts);
        message = ''
          services.nginx.service.virtualHosts.<name>.quic requires using nginxQuic or angie packages,
          which can be achieved by setting `services.nginx.package = pkgs.nginxQuic;` or
          `services.nginx.package = pkgs.angieQuic;`.
        '';
      }

      {
        # The idea is to understand whether there is a virtual host with a listen configuration
        # that requires ACME configuration but has no HTTP listener which will make deterministically fail
        # this operation.
        # Options' priorities are the following at the moment:
        # listen (vhost) > defaultListen (server) > listenAddresses (vhost) > defaultListenAddresses (server)
        assertion =
        let
          hasAtLeastHttpListener = listenOptions: lib.any (listenLine: if listenLine ? proxyProtocol then !listenLine.proxyProtocol else true) listenOptions;
          hasAtLeastDefaultHttpListener = if cfg.defaultListen != [] then hasAtLeastHttpListener cfg.defaultListen else (cfg.defaultListenAddresses != []);
        in
          lib.all (host:
            let
              hasAtLeastVhostHttpListener = if host.listen != [] then hasAtLeastHttpListener host.listen else (host.listenAddresses != []);
              vhostAuthority = host.listen != [] || (cfg.defaultListen == [] && host.listenAddresses != []);
            in
              # Either vhost has precedence and we need a vhost specific http listener
              # Either vhost set nothing and inherit from server settings
              host.enableACME -> ((vhostAuthority && hasAtLeastVhostHttpListener) || (!vhostAuthority && hasAtLeastDefaultHttpListener))
          ) (lib.attrValues virtualHosts);
        message = ''
          services.nginx.virtualHosts.<name>.enableACME requires a HTTP listener
          to answer to ACME requests.
        '';
      }

      {
        assertion = cfg.resolver.ipv4 || cfg.resolver.ipv6;
        message = ''
          At least one of services.nginx.resolver.ipv4 and services.nginx.resolver.ipv6 must be true.
        '';
      }
    ] ++ map (name: mkCertOwnershipAssertion {
      cert = config.security.acme.certs.${name};
      groups = config.users.groups;
      services = [ config.systemd.services.nginx ] ++ lib.optional (cfg.enableReload || vhostCertNames != []) config.systemd.services.nginx-config-reload;
    }) vhostCertNames;

    services.nginx.additionalModules = lib.optional cfg.recommendedBrotliSettings pkgs.nginxModules.brotli
      ++ lib.optional cfg.recommendedZstdSettings pkgs.nginxModules.zstd;

    services.nginx.virtualHosts.localhost = lib.mkIf cfg.statusPage {
      serverAliases = [ "127.0.0.1" ] ++ lib.optional config.networking.enableIPv6 "[::1]";
      listenAddresses = lib.mkDefault ([
        "0.0.0.0"
      ] ++ lib.optional enableIPv6 "[::]");
      locations."/nginx_status" = {
        extraConfig = ''
          stub_status on;
          access_log off;
          allow 127.0.0.1;
          ${lib.optionalString enableIPv6 "allow ::1;"}
          deny all;
        '';
      };
    };

    systemd.services.nginx = {
      description = "Nginx Web Server";
      wantedBy = [ "multi-user.target" ];
      wants = lib.concatLists (map (certName: [ "acme-finished-${certName}.target" ]) vhostCertNames);
      after = [ "network.target" ]
        ++ map (certName: "acme-selfsigned-${certName}.service") vhostCertNames
        ++ map (certName: "acme-${certName}.service") independentCertNames; # avoid loading self-signed key w/ real cert, or vice-versa
      # Nginx needs to be started in order to be able to request certificates
      # (it's hosting the acme challenge after all)
      # This fixes https://github.com/NixOS/nixpkgs/issues/81842
      before = map (certName: "acme-${certName}.service") dependentCertNames;
      stopIfChanged = false;
      preStart = ''
        ${cfg.preStart}
        ${execCommand} -t
      '';

      startLimitIntervalSec = 60;
      serviceConfig = {
        ExecStart = execCommand;
        ExecReload = [
          "${execCommand} -t"
          "${pkgs.coreutils}/bin/kill -HUP $MAINPID"
        ];
        Restart = "always";
        RestartSec = "10s";
        # User and group
        User = cfg.user;
        Group = cfg.group;
        # Runtime directory and mode
        RuntimeDirectory = "nginx";
        RuntimeDirectoryMode = "0750";
        # Cache directory and mode
        CacheDirectory = "nginx";
        CacheDirectoryMode = "0750";
        # Logs directory and mode
        LogsDirectory = "nginx";
        LogsDirectoryMode = "0750";
        # Proc filesystem
        ProcSubset = "pid";
        ProtectProc = "invisible";
        # New file permissions
        UMask = "0027"; # 0640 / 0750
        # Capabilities
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" "CAP_SYS_RESOURCE" ] ++ lib.optionals cfg.enableQuicBPF [ "CAP_SYS_ADMIN" "CAP_NET_ADMIN" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" "CAP_SYS_RESOURCE" ] ++ lib.optionals cfg.enableQuicBPF [ "CAP_SYS_ADMIN" "CAP_NET_ADMIN" ];
        # Security
        NoNewPrivileges = true;
        # Sandboxing (sorted by occurrence in https://www.freedesktop.org/software/systemd/man/systemd.exec.html)
        ProtectSystem = "strict";
        ProtectHome = lib.mkDefault true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = !((builtins.any (mod: (mod.allowMemoryWriteExecute or false)) cfg.package.modules) || (cfg.package == pkgs.openresty));
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @setuid" ]
          ++ lib.optional cfg.enableQuicBPF [ "bpf" ];
      };
    };

    environment.etc."nginx/nginx.conf" = lib.mkIf cfg.enableReload {
      source = configFile;
    };

    # This service waits for all certificates to be available
    # before reloading nginx configuration.
    # sslTargets are added to wantedBy + before
    # which allows the acme-finished-$cert.target to signify the successful updating
    # of certs end-to-end.
    systemd.services.nginx-config-reload = let
      sslServices = map (certName: "acme-${certName}.service") vhostCertNames;
      sslTargets = map (certName: "acme-finished-${certName}.target") vhostCertNames;
    in lib.mkIf (cfg.enableReload || vhostCertNames != []) {
      wants = lib.optionals cfg.enableReload [ "nginx.service" ];
      wantedBy = sslServices ++ [ "multi-user.target" ];
      # Before the finished targets, after the renew services.
      # This service might be needed for HTTP-01 challenges, but we only want to confirm
      # certs are updated _after_ config has been reloaded.
      before = sslTargets;
      after = sslServices;
      restartTriggers = lib.optionals cfg.enableReload [ configFile ];
      # Block reloading if not all certs exist yet.
      # Happens when config changes add new vhosts/certs.
      unitConfig.ConditionPathExists = lib.optionals (sslServices != []) (map (certName: certs.${certName}.directory + "/fullchain.pem") vhostCertNames);
      serviceConfig = {
        Type = "oneshot";
        TimeoutSec = 60;
        ExecCondition = "/run/current-system/systemd/bin/systemctl -q is-active nginx.service";
        ExecStart = "/run/current-system/systemd/bin/systemctl reload nginx.service";
      };
    };

    security.acme.certs = let
      acmePairs = map (vhostConfig: let
        hasRoot = vhostConfig.acmeRoot != null;
      in lib.nameValuePair vhostConfig.serverName {
        group = lib.mkDefault cfg.group;
        # if acmeRoot is null inherit config.security.acme
        # Since config.security.acme.certs.<cert>.webroot's own default value
        # should take precedence set priority higher than lib.mkOptionDefault
        webroot = lib.mkOverride (if hasRoot then 1000 else 2000) vhostConfig.acmeRoot;
        # Also nudge dnsProvider to null in case it is inherited
        dnsProvider = lib.mkOverride (if hasRoot then 1000 else 2000) null;
        extraDomainNames = vhostConfig.serverAliases;
      # Filter for enableACME-only vhosts. Don't want to create dud certs
      }) (lib.filter (vhostConfig: vhostConfig.useACMEHost == null) acmeEnabledVhosts);
    in lib.listToAttrs acmePairs;

    users.users = lib.optionalAttrs (cfg.user == "nginx") {
      nginx = {
        group = cfg.group;
        isSystemUser = true;
        uid = config.ids.uids.nginx;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "nginx") {
      nginx.gid = config.ids.gids.nginx;
    };

    boot.kernelModules = lib.optional (lib.versionAtLeast config.boot.kernelPackages.kernel.version "4.17") "tls";

    # do not delete the default temp directories created upon nginx startup
    systemd.tmpfiles.rules = [
      "X /tmp/systemd-private-%b-nginx.service-*/tmp/nginx_*"
    ];

    services.logrotate.settings.nginx = lib.mapAttrs (_: lib.mkDefault) {
      files = [ "/var/log/nginx/*.log" ];
      frequency = "weekly";
      su = "${cfg.user} ${cfg.group}";
      rotate = 26;
      compress = true;
      delaycompress = true;
      postrotate = "[ ! -f /var/run/nginx/nginx.pid ] || kill -USR1 `cat /var/run/nginx/nginx.pid`";
    };
  };
}
