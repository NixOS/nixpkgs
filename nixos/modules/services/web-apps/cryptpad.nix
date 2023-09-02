{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cryptpad;
  nginx = config.services.nginx;

  inherit (lib) mdDoc;

  # the config isn't json, but a js script which assigns a json value
  conf_file = builtins.toFile "cryptpad_config.js" ''
    module.exports = ${builtins.toJSON cfg.config}
  '';

  # nginx settings
  nginx_main_domain = lib.strings.removePrefix "https://" cfg.config.httpUnsafeOrigin;
  nginx_sandbox_domain = if cfg.config.httpSafeOrigin != null then lib.strings.removePrefix "https://" cfg.config.httpSafeOrigin else nginx_main_domain;
  # config from cryptpad's docs/example.nginx.conf
  # Changes from example:
  # - domain variables
  # - removal of server (obviously not compatible with virtualHosts)
  # - resolver/ssl_trusted_certificate (surprising behaviour? why not use system's??)
  # gixy warnings have also been fixed as per https://github.com/cryptpad/cryptpad/pull/1213
  # Do we want to "nixos-ify" more SSL settings?
  nginx_config = ''
    # CryptPad serves static assets over these two domains.
    # `main_domain` is what users will enter in their address bar.
    # Privileged computation such as key management is handled in this scope
    # UI content is loaded via the `sandbox_domain`.
    # "Content Security Policy" headers prevent content loaded via the sandbox
    # from accessing privileged information.
    # These variables must be different to take advantage of CryptPad's sandboxing techniques.
    # In the event of an XSS vulnerability in CryptPad's front-end code
    # this will limit the amount of information accessible to attackers.
    set $main_domain "${nginx_main_domain}";
    set $sandbox_domain "${nginx_sandbox_domain}";

    # By default CryptPad forbids remote domains from embedding CryptPad documents in iframes.
    # The sandbox domain must always be permitted in order for the platform to function.
    # If you wish to enable remote embedding you may change the value below to "*"
    # as per the commented value.
    set $allowed_origins "https://''${sandbox_domain}";
    #set $allowed_origins "*";

    # CryptPad's dynamic content (websocket traffic and encrypted blobs)
    # can be served over separate domains. Using dedicated domains (or subdomains)
    # for these purposes allows you to move them to a separate machine at a later date
    # if you find that a single machine cannot handle all of your users.
    # If you don't use dedicated domains, this can be the same as $main_domain
    # If you do, they can be added as exceptions to any rules which block connections to remote domains.
    # You can find these variables referenced below in the relevant places
    set $api_domain "${nginx_main_domain}";
    set $files_domain "${nginx_main_domain}";

    # Speeds things up a little bit when resuming a session
    ssl_session_timeout 1d;
    ssl_session_cache shared:MozSSL:10m;
    ssl_session_tickets off;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;

    # HSTS (ngx_http_headers_module is required) (63072000 seconds)
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;

    # OCSP stapling
    ssl_stapling on;
    ssl_stapling_verify on;

    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options nosniff;
    add_header Access-Control-Allow-Origin "''${allowed_origins}";
    add_header Access-Control-Allow-Credentials true;
    # add_header X-Frame-Options "SAMEORIGIN";

    # Opt out of Google's FLoC Network
    add_header Permissions-Policy interest-cohort=();

    # Enable SharedArrayBuffer in Firefox (for .xlsx export)
    add_header Cross-Origin-Resource-Policy cross-origin;
    add_header Cross-Origin-Embedder-Policy require-corp;

    # Insert the path to your CryptPad repository root here
    root /var/lib/cryptpad;
    index index.html;
    error_page 404 /customize.dist/404.html;

    # any static assets loaded with "ver=" in their URL will be cached for a year
    if ($args ~ ver=) {
        set $cacheControl max-age=31536000;
    }
    # This rule overrides the above caching directive and makes things somewhat less efficient.
    # We had inverted them as an optimization, but Safari 16 introduced a bug that interpreted
    # some important headers incorrectly when loading these files from cache.
    # This is why we can't have nice things :(
    if ($uri ~ ^(\/|.*\/|.*\.html)$) {
        set $cacheControl no-cache;
    }

    # Will not set any header if it is emptystring
    add_header Cache-Control $cacheControl;

    # CSS can be dynamically set inline, loaded from the same domain, or from $main_domain
    set $styleSrc   "'unsafe-inline' 'self' https://''${main_domain}";

    # connect-src restricts URLs which can be loaded using script interfaces
    # if you have configured your instance to use a dedicated $files_domain or $api_domain
    # you will need to add them below as: https://''${files_domain} and https://''${api_domain}
    set $connectSrc "'self' https://''${main_domain} blob: wss://''${api_domain} https://''${sandbox_domain}";

    # fonts can be loaded from data-URLs or the main domain
    set $fontSrc    "'self' data: https://''${main_domain}";

    # images can be loaded from anywhere, though we'd like to deprecate this as it allows the use of images for tracking
    set $imgSrc     "'self' data: blob: https://''${main_domain}";

    # frame-src specifies valid sources for nested browsing contexts.
    # this prevents loading any iframes from anywhere other than the sandbox domain
    set $frameSrc   "'self' https://''${sandbox_domain} blob:";

    # specifies valid sources for loading media using video or audio
    set $mediaSrc   "blob:";

    # defines valid sources for webworkers and nested browser contexts
    # deprecated in favour of worker-src and frame-src
    set $childSrc   "https://''${main_domain}";

    # specifies valid sources for Worker, SharedWorker, or ServiceWorker scripts.
    # supercedes child-src but is unfortunately not yet universally supported.
    set $workerSrc  "'self'";

    # script-src specifies valid sources for javascript, including inline handlers
    set $scriptSrc  "'self' resource: https://''${main_domain}";

    # frame-ancestors specifies which origins can embed your CryptPad instance
    # this must include 'self' and your main domain (over HTTPS) in order for CryptPad to work
    # if you have enabled remote embedding via the admin panel then this must be more permissive.
    # note: cryptpad.fr permits web pages served via https: and vector: (element desktop app)
    set $frameAncestors "'self' https://''${main_domain}";
    # set $frameAncestors "'self' https: vector:";

    set $unsafe 0;
    # the following assets are loaded via the sandbox domain
    # they unfortunately still require exceptions to the sandboxing to work correctly.
    if ($uri ~ ^\/(sheet|doc|presentation)\/inner.html.*$) { set $unsafe 1; }
    if ($uri ~ ^\/common\/onlyoffice\/.*\/.*\.html.*$) { set $unsafe 1; }

    # everything except the sandbox domain is a privileged scope, as they might be used to handle keys
    if ($host != $sandbox_domain) { set $unsafe 0; }
    # this iframe is an exception. Office file formats are converted outside of the sandboxed scope
    # because of bugs in Chromium-based browsers that incorrectly ignore headers that are supposed to enable
    # the use of some modern APIs that we require when javascript is run in a cross-origin context.
    # We've applied other sandboxing techniques to mitigate the risk of running WebAssembly in this privileged scope
    if ($uri ~ ^\/unsafeiframe\/inner\.html.*$) { set $unsafe 1; }

    # draw.io uses inline script tags in it's index.html. The hashes are added here.
    if ($uri ~ ^\/components\/drawio\/src\/main\/webapp\/index.html.*$) {
        set $scriptSrc "'self' 'sha256-6zAB96lsBZREqf0sT44BhH1T69sm7HrN34rpMOcWbNo=' 'sha256-6g514VrT/cZFZltSaKxIVNFF46+MFaTSDTPB8WfYK+c=' resource: https://''${main_domain}";
    }

    # privileged contexts allow a few more rights than unprivileged contexts, though limits are still applied
    if ($unsafe) {
        set $scriptSrc "'self' 'unsafe-eval' 'unsafe-inline' resource: https://''${main_domain}";
    }

    # Finally, set all the rules you composed above.
    add_header Content-Security-Policy "default-src 'none'; child-src $childSrc; worker-src $workerSrc; media-src $mediaSrc; style-src $styleSrc; script-src $scriptSrc; connect-src $connectSrc; font-src $fontSrc; img-src $imgSrc; frame-src $frameSrc; frame-ancestors $frameAncestors";

    # The nodejs process can handle all traffic whether accessed over websocket or as static assets
    # We prefer to serve static content from nginx directly and to leave the API server to handle
    # the dynamic content that only it can manage. This is primarily an optimization
    location ^~ /cryptpad_websocket {
        # XXX
        # static assets like blobs and blocks are served by clustered workers in the API server
        # Websocket traffic still needs to be handled by the main process, which means it needs
        # to be hosted on a different port. By default 3003 will be used, though this is configurable
        # via config.websocketPort
        proxy_pass http://${cfg.config.httpAddress}:${toString cfg.config.websocketPort};
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        # WebSocket support (nginx 1.4)
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection upgrade;
    }

    location ^~ /customize.dist/ {
        # This is needed in order to prevent infinite recursion between /customize/ and the root
    }
    # try to load customizeable content via /customize/ and fall back to the default content
    # located at /customize.dist/
    # This is what allows you to override behaviour.
    location ^~ /customize/ {
        rewrite ^/customize/(.*)$ $1 break;
        try_files /customize/$uri /customize.dist/$uri;
    }

    # /api/config is loaded once per page load and is used to retrieve
    # the caching variable which is applied to every other resource
    # which is loaded during that session.
    location ~ ^/api/.*$ {
        proxy_pass http://${cfg.config.httpAddress}:${toString cfg.config.httpPort};
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        # These settings prevent both NGINX and the API server
        # from setting the same headers and creating duplicates
        proxy_hide_header Cross-Origin-Resource-Policy;
        proxy_hide_header Cross-Origin-Embedder-Policy;
    }

    # Requests for blobs and blocks are now proxied to the API server
    # This simplifies NGINX path configuration in the event they are being hosted in a non-standard location
    # or with odd unexpected permissions. Serving blobs in this manner also means that it will be possible to
    # enforce access control for them, though this is not yet implemented.
    # Access control (via TOTP 2FA) has been added to blocks, so they can be handled with the same directives.
    location ~ ^/(blob|block)/.*$ {
        if ($request_method = 'OPTIONS') {
            # repeat headers see https://github.com/yandex/gixy/blob/master/docs/en/plugins/addheaderredefinition.md
            add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Content-Type-Options nosniff;
            add_header Access-Control-Allow-Origin "''${allowed_origins}";
            add_header Access-Control-Allow-Credentials true;
            add_header Permissions-Policy interest-cohort=();
            add_header Cross-Origin-Resource-Policy cross-origin;
            add_header Cross-Origin-Embedder-Policy require-corp;
            add_header Cache-Control $cacheControl;
            add_header Content-Security-Policy "default-src 'none'; child-src $childSrc; worker-src $workerSrc; media-src $mediaSrc; style-src $styleSrc; script-src $scriptSrc; connect-src $connectSrc; font-src $fontSrc; img-src $imgSrc; frame-src $frameSrc; frame-ancestors $frameAncestors";
            # headers for OPTIONS
            add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
            add_header 'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range';
            add_header 'Access-Control-Max-Age' 1728000;
            add_header 'Content-Type' 'application/octet-stream; charset=utf-8';
            add_header 'Content-Length' 0;
            return 204;
        }
        # Since we are proxying to the API server these headers can get duplicated
        # so we hide them
        proxy_hide_header 'X-Content-Type-Options';
        proxy_hide_header 'Access-Control-Allow-Origin';
        proxy_hide_header 'Permissions-Policy';
        proxy_hide_header 'X-XSS-Protection';
        proxy_pass http://${cfg.config.httpAddress}:${toString cfg.config.httpPort};
    }

    # The nodejs server has some built-in forwarding rules to prevent
    # URLs like /pad from resulting in a 404. This simply adds a trailing slash
    # to a variety of applications.
    location ~ ^/(register|login|recovery|settings|user|pad|drive|poll|slide|code|whiteboard|file|media|profile|contacts|todo|filepicker|debug|kanban|sheet|support|admin|notifications|teams|calendar|presentation|doc|form|report|convert|checkup|diagram)$ {
        rewrite ^(.*)$ $1/ redirect;
    }

    # Finally, serve anything the above exceptions don't govern.
    try_files /customize/www/$uri /customize/www/$uri/index.html /www/$uri /www/$uri/index.html /customize/$uri;
  '';
in {

  options.services.cryptpad = {
    enable = mkEnableOption (mdDoc "the Cryptpad service");

    package = mkOption {
      type = types.package;
      default = pkgs.cryptpad;
      defaultText = "pkgs.cryptpad";
      description = mdDoc "Cryptpad package to use";
    };

    nginx = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = mdDoc ''
          Manage cryptpad's nginx configuration.
          The virtual hosts are taken from config.services.cryptpad.config's httpUnsafeOrigin and httpSafeOrigin
        '';
      };
    };

    confinement = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable the nixos systemd.services.cryptpad.confinement setting, including the necessary
        extra bind mounts.
      '';
    };

    config = mkOption {
      description = mdDoc ''
        cryptpad backend settings.
        Some of the settings here (like backend ports) will be re-used for nginx config default as well
        See https://github.com/cryptpad/cryptpad/blob/main/config/config.example.js for more extensive
        comments and keys not described here
        Note paths cannot be changed easily as they are also present indirectly in the nginx config
        (for files that nginx serves directly)
        Once setup, test your instance through `https://<domain>/checkup/`
      '';
      type = types.submodule {
        freeformType = (pkgs.formats.json {}).type;
        options = {
          httpUnsafeOrigin = mkOption {
            type = types.str;
            example = "https://cryptpad.example.com";
            description = mdDoc "Main cryptpad domain url";
          };
          httpSafeOrigin = mkOption {
            type = types.nullOr types.str;
            example = "https://cryptpad-sandbox.example.com. Apparently optional but recommended.";
            description = mdDoc "Cryptpad sandbox url";
          };
          httpAddress = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = mdDoc "Cryptpad listen address, also used in nginx to contact it";
          };
          httpPort = mkOption {
            type = types.int;
            default = 3000;
            description = mdDoc "Backend main port";
          };
          httpSafePort = mkOption {
            type = types.int;
            default = 3001;
            description = mdDoc "Backend sandbox port. Does not appear to be used...";
          };
          websocketPort = mkOption {
            type = types.int;
            default = 3003;
            description = mdDoc "Backend websocket port";
          };
          maxWorkers = mkOption {
            type = types.nullOr types.int;
            default = null;
            description = mdDoc "Number of child processes, defaults to number of cores available";
          };
          adminKeys = mkOption {
            type = types.listOf types.str;
            default = [];
            description = mdDoc "Admins allowed to admin panel. Keys can be found in the settings page of the user";
            example = [ "[cryptpad-user1@my.awesome.website/YZgXQxKR0Rcb6r6CmxHPdAGLVludrAF2lEnkbx1vVOo=]" ];
          };
          logToStdout = mkOption {
            type = types.bool;
            default = true;
            description = mdDoc "Whether to log to stdout (will go to systemd service). Level can be changed with logLevel.";
          };
          blockDailyCheck = mkOption {
            type = types.bool;
            default = true;
            description = mdDoc "Disable telemetry. This setting is only effective if the 'Disable server telemetry' setting in the admin menu has been untouched, and will be ignored once set there either way.";
          };
          installMethod = mkOption {
            type = types.str;
            default = "nixos";
            description = mdDoc ''
              Install method is listed in telemetry if you agree to it through the consentToContact
              setting in the admin panel.
            '';
          };
          # Note settings like blockPath also require change in the nginx config,
          # and thus cannot safely be set just here for now.
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      users.users.cryptpad = {
        isSystemUser = true;
        group = "cryptpad";
      };
      users.groups.cryptpad = {};

      systemd.services.cryptpad = {
        description = "Cryptpad service";
        wantedBy = [ "multi-user.target" ];
        after = [ "networking.target" ];
        serviceConfig = {
          User = "cryptpad";
          Environment = [
            "CRYPTPAD_CONFIG=${conf_file}"
            "HOME=%S/cryptpad"
          ];
          ExecStart = "${cfg.package}/bin/cryptpad";
          PrivateTmp = true;
          Restart = "always";
          StateDirectory = "cryptpad";
          WorkingDirectory = "%S/cryptpad";
        };
      };
    }
    (mkIf cfg.confinement {
      systemd.services.cryptpad = {
        serviceConfig.BindReadOnlyPaths = [
          conf_file
          # apparently needs proc for workers management
          "/proc"
          "/dev/urandom"
        ] ++ (if ! cfg.config.blockDailyCheck then [
          "/etc/resolv.conf"
          "/etc/hosts"
        ] else []);
        confinement = {
          enable = true;
          binSh = null;
          mode = "chroot-only";
        };
      };
    })
    (mkIf cfg.nginx.enable {
      assertions = [
        { assertion = nginx.enable;
          message = "nginx must be enabled";
        }
        { assertion = lib.strings.hasPrefix "https://" cfg.config.httpUnsafeOrigin;
          message = "services.cryptpad.config.httpUnsafeOrigin must start with https://";
        }
        { assertion = cfg.config.httpSafeOrigin == null  || lib.strings.hasPrefix "https://" cfg.config.httpSafeOrigin;
          message = "services.cryptpad.config.httpSafeOrigin must start with https:// (or be unset)";
        }
      ];
      services.nginx.virtualHosts = mkMerge [
        {
          ${nginx_main_domain} = {
            forceSSL = lib.mkDefault true;
            # Probably not wise to automatically enable acme?...
            enableACME = lib.mkDefault config.security.acme.acceptTerms;
            extraConfig = nginx_config;
          };
        }
        (mkIf (cfg.config.httpSafeOrigin != null) {
          ${nginx_sandbox_domain} = {
            forceSSL = lib.mkDefault true;
            enableACME = lib.mkDefault config.security.acme.acceptTerms;
            extraConfig = nginx_config;
          };
        })
      ];
    })
  ]);
}
