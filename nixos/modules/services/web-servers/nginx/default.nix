{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nginx;
  inherit (config.security.acme) certs;
  vhostsConfigs = mapAttrsToList (vhostName: vhostConfig: vhostConfig) virtualHosts;
  acmeEnabledVhosts = filter (vhostConfig: vhostConfig.enableACME || vhostConfig.useACMEHost != null) vhostsConfigs;
  dependentCertNames = unique (map (hostOpts: hostOpts.certName) acmeEnabledVhosts);
  virtualHosts = mapAttrs (vhostName: vhostConfig:
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
    } // (optionalAttrs (vhostConfig.enableACME || vhostConfig.useACMEHost != null) {
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
  compressMimeTypes = [
    "application/atom+xml"
    "application/geo+json"
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
    "text/html"
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

  upstreamConfig = toString (flip mapAttrsToList cfg.upstreams (name: upstream: ''
    upstream ${name} {
      ${toString (flip mapAttrsToList upstream.servers (name: server: ''
        server ${name} ${optionalString server.backup "backup"};
      ''))}
      ${upstream.extraConfig}
    }
  ''));

  commonHttpConfig = ''
      # The mime type definitions included with nginx are very incomplete, so
      # we use a list of mime types from the mailcap package, which is also
      # used by most other Linux distributions by default.
      include ${pkgs.mailcap}/etc/nginx/mime.types;
      # When recommendedOptimisation is disabled nginx fails to start because the mailmap mime.types database
      # contains 1026 enries and the default is only 1024. Setting to a higher number to remove the need to
      # overwrite it because nginx does not allow duplicated settings.
      types_hash_max_size 4096;

      include ${cfg.package}/conf/fastcgi.conf;
      include ${cfg.package}/conf/uwsgi_params;

      default_type application/octet-stream;
  '';

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
      ${commonHttpConfig}

      ${optionalString (cfg.resolver.addresses != []) ''
        resolver ${toString cfg.resolver.addresses} ${optionalString (cfg.resolver.valid != "") "valid=${cfg.resolver.valid}"} ${optionalString (!cfg.resolver.ipv6) "ipv6=off"};
      ''}
      ${upstreamConfig}

      ${optionalString cfg.recommendedOptimisation ''
        # optimisation
        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
      ''}

      ssl_protocols ${cfg.sslProtocols};
      ${optionalString (cfg.sslCiphers != null) "ssl_ciphers ${cfg.sslCiphers};"}
      ${optionalString (cfg.sslDhparam != null) "ssl_dhparam ${cfg.sslDhparam};"}

      ${optionalString cfg.recommendedTlsSettings ''
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

      ${optionalString cfg.recommendedBrotliSettings ''
        brotli on;
        brotli_static on;
        brotli_comp_level 5;
        brotli_window 512k;
        brotli_min_length 256;
        brotli_types ${lib.concatStringsSep " " compressMimeTypes};
        brotli_buffers 32 8k;
      ''}

      ${optionalString cfg.recommendedGzipSettings ''
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

      ${optionalString cfg.recommendedProxySettings ''
        proxy_redirect          off;
        proxy_connect_timeout   ${cfg.proxyTimeout};
        proxy_send_timeout      ${cfg.proxyTimeout};
        proxy_read_timeout      ${cfg.proxyTimeout};
        proxy_http_version      1.1;
        include ${recommendedProxyConfig};
      ''}

      ${optionalString (cfg.mapHashBucketSize != null) ''
        map_hash_bucket_size ${toString cfg.mapHashBucketSize};
      ''}

      ${optionalString (cfg.mapHashMaxSize != null) ''
        map_hash_max_size ${toString cfg.mapHashMaxSize};
      ''}

      ${optionalString (cfg.serverNamesHashBucketSize != null) ''
        server_names_hash_bucket_size ${toString cfg.serverNamesHashBucketSize};
      ''}

      ${optionalString (cfg.serverNamesHashMaxSize != null) ''
        server_names_hash_max_size ${toString cfg.serverNamesHashMaxSize};
      ''}

      # $connection_upgrade is used for websocket proxying
      map $http_upgrade $connection_upgrade {
          default upgrade;
          '''      close;
      }
      client_max_body_size ${cfg.clientMaxBodySize};

      server_tokens ${if cfg.serverTokens then "on" else "off"};

      ${optionalString cfg.proxyCache.enable ''
        proxy_cache_path /var/cache/nginx keys_zone=${cfg.proxyCache.keysZoneName}:${cfg.proxyCache.keysZoneSize}
                                          levels=${cfg.proxyCache.levels}
                                          use_temp_path=${if cfg.proxyCache.useTempPath then "on" else "off"}
                                          inactive=${cfg.proxyCache.inactive}
                                          max_size=${cfg.proxyCache.maxSize};
      ''}

      ${cfg.commonHttpConfig}

      ${vhosts}

      ${optionalString cfg.statusPage ''
        server {
          listen ${toString cfg.defaultHTTPListenPort};
          ${optionalString enableIPv6 "listen [::]:${toString cfg.defaultHTTPListenPort};" }

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
      ${commonHttpConfig}
      ${cfg.httpConfig}
    }''}

    ${optionalString (cfg.streamConfig != "") ''
    stream {
      ${cfg.streamConfig}
    }
    ''}

    ${cfg.appendConfig}
  '';

  configPath = if cfg.enableReload
    then "/etc/nginx/nginx.conf"
    else finalConfigFile;

  execCommand = "${cfg.package}/bin/nginx -c '${configPath}'";

  vhosts = concatStringsSep "\n" (mapAttrsToList (vhostName: vhost:
    let
        onlySSL = vhost.onlySSL || vhost.enableSSL;
        hasSSL = onlySSL || vhost.addSSL || vhost.forceSSL;

        defaultListen =
          if vhost.listen != [] then vhost.listen
          else
            let addrs = if vhost.listenAddresses != [] then vhost.listenAddresses else cfg.defaultListenAddresses;
            in optionals (hasSSL || vhost.rejectSSL) (map (addr: { inherit addr; port = cfg.defaultSSLListenPort; ssl = true; }) addrs)
              ++ optionals (!onlySSL) (map (addr: { inherit addr; port = cfg.defaultHTTPListenPort; ssl = false; }) addrs);

        hostListen =
          if vhost.forceSSL
            then filter (x: x.ssl) defaultListen
            else defaultListen;

        listenString = { addr, port, ssl, extraParameters ? [], ... }:
          (if ssl && vhost.http3 then "
          # UDP listener for **QUIC+HTTP/3
          listen ${addr}:${toString port} http3 "
          + optionalString vhost.default "default_server "
          + optionalString vhost.reuseport "reuseport "
          + optionalString (extraParameters != []) (concatStringsSep " " extraParameters)
          + ";" else "")
          + "

            listen ${addr}:${toString port} "
          + optionalString (ssl && vhost.http2) "http2 "
          + optionalString ssl "ssl "
          + optionalString vhost.default "default_server "
          + optionalString vhost.reuseport "reuseport "
          + optionalString (extraParameters != []) (concatStringsSep " " extraParameters)
          + ";";

        redirectListen = filter (x: !x.ssl) defaultListen;

        acmeLocation = optionalString (vhost.enableACME || vhost.useACMEHost != null) ''
          # Rule for legitimate ACME Challenge requests (like /.well-known/acme-challenge/xxxxxxxxx)
          # We use ^~ here, so that we don't check any regexes (which could
          # otherwise easily override this intended match accidentally).
          location ^~ /.well-known/acme-challenge/ {
            ${optionalString (vhost.acmeFallbackHost != null) "try_files $uri @acme-fallback;"}
            ${optionalString (vhost.acmeRoot != null) "root ${vhost.acmeRoot};"}
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
            location / {
              return 301 http${optionalString hasSSL "s"}://${vhost.globalRedirect}$request_uri;
            }
          ''}
          ${optionalString hasSSL ''
            ssl_certificate ${vhost.sslCertificate};
            ssl_certificate_key ${vhost.sslCertificateKey};
          ''}
          ${optionalString (hasSSL && vhost.sslTrustedCertificate != null) ''
            ssl_trusted_certificate ${vhost.sslTrustedCertificate};
          ''}
          ${optionalString vhost.rejectSSL ''
            ssl_reject_handshake on;
          ''}
          ${optionalString (hasSSL && vhost.kTLS) ''
            ssl_conf_command Options KTLS;
          ''}

          ${optionalString (hasSSL && vhost.http3) ''
            # Advertise that HTTP/3 is available
            add_header Alt-Svc 'h3=":443"; ma=86400' always;
          ''}

          ${mkBasicAuth vhostName vhost}

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
      ${concatStringsSep "\n"
        (mapAttrsToList (n: v: ''fastcgi_param ${n} "${v}";'')
          (optionalAttrs (config.fastcgiParams != {})
            (defaultFastcgiParams // config.fastcgiParams)))}
      ${optionalString (config.index != null) "index ${config.index};"}
      ${optionalString (config.tryFiles != null) "try_files ${config.tryFiles};"}
      ${optionalString (config.root != null) "root ${config.root};"}
      ${optionalString (config.alias != null) "alias ${config.alias};"}
      ${optionalString (config.return != null) "return ${config.return};"}
      ${config.extraConfig}
      ${optionalString (config.proxyPass != null && config.recommendedProxySettings) "include ${recommendedProxyConfig};"}
      ${mkBasicAuth "sublocation" config}
    }
  '') (sortProperties (mapAttrsToList (k: v: v // { location = k; }) locations)));

  mkBasicAuth = name: zone: optionalString (zone.basicAuthFile != null || zone.basicAuth != {}) (let
    auth_file = if zone.basicAuthFile != null
      then zone.basicAuthFile
      else mkHtpasswd name zone.basicAuth;
  in ''
    auth_basic secured;
    auth_basic_user_file ${auth_file};
  '');
  mkHtpasswd = name: authDef: pkgs.writeText "${name}.htpasswd" (
    concatStringsSep "\n" (mapAttrsToList (user: password: ''
      ${user}:{PLAIN}${password}
    '') authDef)
  );

  mkCertOwnershipAssertion = import ../../../security/acme/mk-cert-ownership-assertion.nix;

  snakeOilCert = pkgs.runCommand "nginx-config-validate-cert" { nativeBuildInputs = [ pkgs.openssl.bin ]; } ''
    mkdir $out
    openssl genrsa -des3 -passout pass:xxxxx -out server.pass.key 2048
    openssl rsa -passin pass:xxxxx -in server.pass.key -out $out/server.key
    openssl req -new -key $out/server.key -out server.csr \
    -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=IT Department/CN=example.com"
    openssl x509 -req -days 1 -in server.csr -signkey $out/server.key -out $out/server.crt
  '';
  validatedConfigFile = pkgs.runCommand "validated-nginx.conf" { nativeBuildInputs = [ cfg.package ]; } ''
    # nginx absolutely wants to read the certificates even when told to only validate config, so let's provide fake certs
    sed ${configFile} \
    -e "s|ssl_certificate .*;|ssl_certificate ${snakeOilCert}/server.crt;|g" \
    -e "s|ssl_trusted_certificate .*;|ssl_trusted_certificate ${snakeOilCert}/server.crt;|g" \
    -e "s|ssl_certificate_key .*;|ssl_certificate_key ${snakeOilCert}/server.key;|g" \
    > conf

    LD_PRELOAD=${pkgs.libredirect}/lib/libredirect.so \
      NIX_REDIRECTS="/etc/resolv.conf=/dev/null" \
      nginx -t -c $(readlink -f ./conf) > out 2>&1 || true
    if ! grep -q "syntax is ok" out; then
      echo nginx config validation failed.
      echo config was ${configFile}.
      echo 'in case of false positive, set `services.nginx.validateConfig` to false.'
      echo nginx output:
      cat out
      exit 1
    fi
    cp ${configFile} $out
  '';

  finalConfigFile = if cfg.validateConfig then validatedConfigFile else configFile;
in

{
  options = {
    services.nginx = {
      enable = mkEnableOption (lib.mdDoc "Nginx Web Server");

      statusPage = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable status page reachable from localhost on http://127.0.0.1/nginx_status.
        '';
      };

      recommendedTlsSettings = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable recommended TLS settings.
        '';
      };

      recommendedOptimisation = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable recommended optimisation settings.
        '';
      };

      recommendedBrotliSettings = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable recommended brotli settings. Learn more about compression in Brotli format [here](https://github.com/google/ngx_brotli/blob/master/README.md).

          This adds `pkgs.nginxModules.brotli` to `services.nginx.additionalModules`.
        '';
      };

      recommendedGzipSettings = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable recommended gzip settings.
        '';
      };

      recommendedProxySettings = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to enable recommended proxy settings if a vhost does not specify the option manually.
        '';
      };

      proxyTimeout = mkOption {
        type = types.str;
        default = "60s";
        example = "20s";
        description = lib.mdDoc ''
          Change the proxy related timeouts in recommendedProxySettings.
        '';
      };

      defaultListenAddresses = mkOption {
        type = types.listOf types.str;
        default = [ "0.0.0.0" ] ++ optional enableIPv6 "[::0]";
        defaultText = literalExpression ''[ "0.0.0.0" ] ++ lib.optional config.networking.enableIPv6 "[::0]"'';
        example = literalExpression ''[ "10.0.0.12" "[2002:a00:1::]" ]'';
        description = lib.mdDoc ''
          If vhosts do not specify listenAddresses, use these addresses by default.
        '';
      };

      defaultHTTPListenPort = mkOption {
        type = types.port;
        default = 80;
        example = 8080;
        description = lib.mdDoc ''
          If vhosts do not specify listen.port, use these ports for HTTP by default.
        '';
      };

      defaultSSLListenPort = mkOption {
        type = types.port;
        default = 443;
        example = 8443;
        description = lib.mdDoc ''
          If vhosts do not specify listen.port, use these ports for SSL by default.
        '';
      };

      package = mkOption {
        default = pkgs.nginxStable;
        defaultText = literalExpression "pkgs.nginxStable";
        type = types.package;
        apply = p: p.override {
          modules = lib.unique (p.modules ++ cfg.additionalModules);
        };
        description = lib.mdDoc ''
          Nginx package to use. This defaults to the stable version. Note
          that the nginx team recommends to use the mainline version which
          available in nixpkgs as `nginxMainline`.
        '';
      };

      validateConfig = mkOption {
        default = pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform;
        defaultText = literalExpression "pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform";
        type = types.bool;
        description = lib.mdDoc ''
          Validate the generated nginx config at build time. The check is not very robust and can be disabled in case of false positives. This is notably the case when cross-compiling or when using `include` with files outside of the store.
        '';
      };

      additionalModules = mkOption {
        default = [];
        type = types.listOf (types.attrsOf types.anything);
        example = literalExpression "[ pkgs.nginxModules.echo ]";
        description = lib.mdDoc ''
          Additional [third-party nginx modules](https://www.nginx.com/resources/wiki/modules/)
          to install. Packaged modules are available in `pkgs.nginxModules`.
        '';
      };

      logError = mkOption {
        default = "stderr";
        type = types.str;
        description = lib.mdDoc ''
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

      preStart =  mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Shell commands executed before the service's nginx is started.
        '';
      };

      config = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
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

      appendConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Configuration lines appended to the generated Nginx
          configuration file. Commonly used by different modules
          providing http snippets. {option}`appendConfig`
          can be specified more than once and it's value will be
          concatenated (contrary to {option}`config` which
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
        description = lib.mdDoc ''
          With nginx you must provide common http context definitions before
          they are used, e.g. log_format, resolver, etc. inside of server
          or location contexts. Use this attribute to set these definitions
          at the appropriate location.
        '';
      };

      httpConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Configuration lines to be set inside the http block.
          This is mutually exclusive with the structured configuration
          via virtualHosts and the recommendedXyzSettings configuration
          options. See appendHttpConfig for appending to the generated http block.
        '';
      };

      streamConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          server {
            listen 127.0.0.1:53 udp reuseport;
            proxy_timeout 20s;
            proxy_pass 192.168.0.1:53535;
          }
        '';
        description = lib.mdDoc ''
          Configuration lines to be set inside the stream block.
        '';
      };

      eventsConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Configuration lines to be set inside the events block.
        '';
      };

      appendHttpConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Configuration lines to be appended to the generated http block.
          This is mutually exclusive with using config and httpConfig for
          specifying the whole http block verbatim.
        '';
      };

      enableReload = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Reload nginx when configuration file changes (instead of restart).
          The configuration file is exposed at {file}`/etc/nginx/nginx.conf`.
          See also `systemd.services.*.restartIfChanged`.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "nginx";
        description = lib.mdDoc "User account under which nginx runs.";
      };

      group = mkOption {
        type = types.str;
        default = "nginx";
        description = lib.mdDoc "Group account under which nginx runs.";
      };

      serverTokens = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Show nginx version in headers and error pages.";
      };

      clientMaxBodySize = mkOption {
        type = types.str;
        default = "10m";
        description = lib.mdDoc "Set nginx global client_max_body_size.";
      };

      sslCiphers = mkOption {
        type = types.nullOr types.str;
        # Keep in sync with https://ssl-config.mozilla.org/#server=nginx&config=intermediate
        default = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
        description = lib.mdDoc "Ciphers to choose from when negotiating TLS handshakes.";
      };

      sslProtocols = mkOption {
        type = types.str;
        default = "TLSv1.2 TLSv1.3";
        example = "TLSv1 TLSv1.1 TLSv1.2 TLSv1.3";
        description = lib.mdDoc "Allowed TLS protocol versions.";
      };

      sslDhparam = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/path/to/dhparams.pem";
        description = lib.mdDoc "Path to DH parameters file.";
      };

      proxyResolveWhileRunning = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Resolves domains of proxyPass targets at runtime
          and not only at start, you have to set
          services.nginx.resolver, too.
        '';
      };

      mapHashBucketSize = mkOption {
        type = types.nullOr (types.enum [ 32 64 128 ]);
        default = null;
        description = lib.mdDoc ''
            Sets the bucket size for the map variables hash tables. Default
            value depends on the processor’s cache line size.
          '';
      };

      mapHashMaxSize = mkOption {
        type = types.nullOr types.ints.positive;
        default = null;
        description = lib.mdDoc ''
            Sets the maximum size of the map variables hash tables.
          '';
      };

      serverNamesHashBucketSize = mkOption {
        type = types.nullOr types.ints.positive;
        default = null;
        description = lib.mdDoc ''
            Sets the bucket size for the server names hash tables. Default
            value depends on the processor’s cache line size.
          '';
      };

      serverNamesHashMaxSize = mkOption {
        type = types.nullOr types.ints.positive;
        default = null;
        description = lib.mdDoc ''
            Sets the maximum size of the server names hash tables.
          '';
      };

      proxyCache = mkOption {
        type = types.submodule {
          options = {
            enable = mkEnableOption (lib.mdDoc "Enable proxy cache");

            keysZoneName = mkOption {
              type = types.str;
              default = "cache";
              example = "my_cache";
              description = lib.mdDoc "Set name to shared memory zone.";
            };

            keysZoneSize = mkOption {
              type = types.str;
              default = "10m";
              example = "32m";
              description = lib.mdDoc "Set size to shared memory zone.";
            };

            levels = mkOption {
              type = types.str;
              default = "1:2";
              example = "1:2:2";
              description = lib.mdDoc ''
                The levels parameter defines structure of subdirectories in cache: from
                1 to 3, each level accepts values 1 or 2. Сan be used any combination of
                1 and 2 in these formats: x, x:x and x:x:x.
              '';
            };

            useTempPath = mkOption {
              type = types.bool;
              default = false;
              example = true;
              description = lib.mdDoc ''
                Nginx first writes files that are destined for the cache to a temporary
                storage area, and the use_temp_path=off directive instructs Nginx to
                write them to the same directories where they will be cached. Recommended
                that you set this parameter to off to avoid unnecessary copying of data
                between file systems.
              '';
            };

            inactive = mkOption {
              type = types.str;
              default = "10m";
              example = "1d";
              description = lib.mdDoc ''
                Cached data that has not been accessed for the time specified by
                the inactive parameter is removed from the cache, regardless of
                its freshness.
              '';
            };

            maxSize = mkOption {
              type = types.str;
              default = "1g";
              example = "2048m";
              description = lib.mdDoc "Set maximum cache size";
            };
          };
        };
        default = {};
        description = lib.mdDoc "Configure proxy cache";
      };

      resolver = mkOption {
        type = types.submodule {
          options = {
            addresses = mkOption {
              type = types.listOf types.str;
              default = [];
              example = literalExpression ''[ "[::1]" "127.0.0.1:5353" ]'';
              description = lib.mdDoc "List of resolvers to use";
            };
            valid = mkOption {
              type = types.str;
              default = "";
              example = "30s";
              description = lib.mdDoc ''
                By default, nginx caches answers using the TTL value of a response.
                An optional valid parameter allows overriding it
              '';
            };
            ipv6 = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                By default, nginx will look up both IPv4 and IPv6 addresses while resolving.
                If looking up of IPv6 addresses is not desired, the ipv6=off parameter can be
                specified.
              '';
            };
          };
        };
        description = lib.mdDoc ''
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
                    description = lib.mdDoc ''
                      Marks the server as a backup server. It will be passed
                      requests when the primary servers are unavailable.
                    '';
                  };
                };
              });
              description = lib.mdDoc ''
                Defines the address and other parameters of the upstream servers.
              '';
              default = {};
              example = { "127.0.0.1:8000" = {}; };
            };
            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = lib.mdDoc ''
                These lines go to the end of the upstream verbatim.
              '';
            };
          };
        });
        description = lib.mdDoc ''
          Defines a group of servers to use as proxy target.
        '';
        default = {};
        example = literalExpression ''
          "backend_server" = {
            servers = { "127.0.0.1:8000" = {}; };
            extraConfig = ''''
              keepalive 16;
            '''';
          };
        '';
      };

      virtualHosts = mkOption {
        type = types.attrsOf (types.submodule (import ./vhost-options.nix {
          inherit config lib;
        }));
        default = {
          localhost = {};
        };
        example = literalExpression ''
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
        description = lib.mdDoc "Declarative vhost config";
      };
    };
  };

  imports = [
    (mkRemovedOptionModule [ "services" "nginx" "stateDir" ] ''
      The Nginx log directory has been moved to /var/log/nginx, the cache directory
      to /var/cache/nginx. The option services.nginx.stateDir has been removed.
    '')
  ];

  config = mkIf cfg.enable {
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
        assertion = all (host: with host;
          count id [ addSSL (onlySSL || enableSSL) forceSSL rejectSSL ] <= 1
        ) (attrValues virtualHosts);
        message = ''
          Options services.nginx.service.virtualHosts.<name>.addSSL,
          services.nginx.virtualHosts.<name>.onlySSL,
          services.nginx.virtualHosts.<name>.forceSSL and
          services.nginx.virtualHosts.<name>.rejectSSL are mutually exclusive.
        '';
      }

      {
        assertion = any (host: host.rejectSSL) (attrValues virtualHosts) -> versionAtLeast cfg.package.version "1.19.4";
        message = ''
          services.nginx.virtualHosts.<name>.rejectSSL requires nginx version
          1.19.4 or above; see the documentation for services.nginx.package.
        '';
      }

      {
        assertion = any (host: host.kTLS) (attrValues virtualHosts) -> versionAtLeast cfg.package.version "1.21.4";
        message = ''
          services.nginx.virtualHosts.<name>.kTLS requires nginx version
          1.21.4 or above; see the documentation for services.nginx.package.
        '';
      }

      {
        assertion = all (host: !(host.enableACME && host.useACMEHost != null)) (attrValues virtualHosts);
        message = ''
          Options services.nginx.service.virtualHosts.<name>.enableACME and
          services.nginx.virtualHosts.<name>.useACMEHost are mutually exclusive.
        '';
      }
    ] ++ map (name: mkCertOwnershipAssertion {
      inherit (cfg) group user;
      cert = config.security.acme.certs.${name};
      groups = config.users.groups;
    }) dependentCertNames;

    services.nginx.additionalModules = optional cfg.recommendedBrotliSettings pkgs.nginxModules.brotli;

    systemd.services.nginx = {
      description = "Nginx Web Server";
      wantedBy = [ "multi-user.target" ];
      wants = concatLists (map (certName: [ "acme-finished-${certName}.target" ]) dependentCertNames);
      after = [ "network.target" ] ++ map (certName: "acme-selfsigned-${certName}.service") dependentCertNames;
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
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" "CAP_SYS_RESOURCE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" "CAP_SYS_RESOURCE" ];
        # Security
        NoNewPrivileges = true;
        # Sandboxing (sorted by occurrence in https://www.freedesktop.org/software/systemd/man/systemd.exec.html)
        ProtectSystem = "strict";
        ProtectHome = mkDefault true;
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
          ++ optionals ((cfg.package != pkgs.tengine) && (cfg.package != pkgs.openresty) && (!lib.any (mod: (mod.disableIPC or false)) cfg.package.modules)) [ "~@ipc" ];
      };
    };

    environment.etc."nginx/nginx.conf" = mkIf cfg.enableReload {
      source = finalConfigFile;
    };

    # This service waits for all certificates to be available
    # before reloading nginx configuration.
    # sslTargets are added to wantedBy + before
    # which allows the acme-finished-$cert.target to signify the successful updating
    # of certs end-to-end.
    systemd.services.nginx-config-reload = let
      sslServices = map (certName: "acme-${certName}.service") dependentCertNames;
      sslTargets = map (certName: "acme-finished-${certName}.target") dependentCertNames;
    in mkIf (cfg.enableReload || sslServices != []) {
      wants = optionals cfg.enableReload [ "nginx.service" ];
      wantedBy = sslServices ++ [ "multi-user.target" ];
      # Before the finished targets, after the renew services.
      # This service might be needed for HTTP-01 challenges, but we only want to confirm
      # certs are updated _after_ config has been reloaded.
      before = sslTargets;
      after = sslServices;
      restartTriggers = optionals cfg.enableReload [ finalConfigFile ];
      # Block reloading if not all certs exist yet.
      # Happens when config changes add new vhosts/certs.
      unitConfig.ConditionPathExists = optionals (sslServices != []) (map (certName: certs.${certName}.directory + "/fullchain.pem") dependentCertNames);
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
      in nameValuePair vhostConfig.serverName {
        group = mkDefault cfg.group;
        # if acmeRoot is null inherit config.security.acme
        # Since config.security.acme.certs.<cert>.webroot's own default value
        # should take precedence set priority higher than mkOptionDefault
        webroot = mkOverride (if hasRoot then 1000 else 2000) vhostConfig.acmeRoot;
        # Also nudge dnsProvider to null in case it is inherited
        dnsProvider = mkOverride (if hasRoot then 1000 else 2000) null;
        extraDomainNames = vhostConfig.serverAliases;
      # Filter for enableACME-only vhosts. Don't want to create dud certs
      }) (filter (vhostConfig: vhostConfig.useACMEHost == null) acmeEnabledVhosts);
    in listToAttrs acmePairs;

    users.users = optionalAttrs (cfg.user == "nginx") {
      nginx = {
        group = cfg.group;
        isSystemUser = true;
        uid = config.ids.uids.nginx;
      };
    };

    users.groups = optionalAttrs (cfg.group == "nginx") {
      nginx.gid = config.ids.gids.nginx;
    };

    services.logrotate.settings.nginx = mapAttrs (_: mkDefault) {
      files = "/var/log/nginx/*.log";
      frequency = "weekly";
      su = "${cfg.user} ${cfg.group}";
      rotate = 26;
      compress = true;
      delaycompress = true;
      postrotate = "[ ! -f /var/run/nginx/nginx.pid ] || kill -USR1 `cat /var/run/nginx/nginx.pid`";
    };
  };
}
