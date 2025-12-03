{
  config,
  lib,
  pkgs,
  ...
}:

let

  inherit (lib)
    generators
    mapAttrs
    mkDefault
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    types
    ;

  cfg = config.services.grav;

  yamlFormat = pkgs.formats.yaml { };

  poolName = "grav";

  servedRoot = pkgs.runCommand "grav-served-root" { } ''
    cp --reflink=auto --no-preserve=mode -r ${cfg.package} $out

    for p in assets images user system/config; do
      rm -rf $out/$p
      ln -sf /var/lib/grav/$p $out/$p
    done
  '';

  systemSettingsYaml = yamlFormat.generate "grav-settings.yaml" cfg.systemSettings;

in
{
  options.services.grav = {
    enable = mkEnableOption "grav";

    package = mkPackageOption pkgs "grav" { };

    root = mkOption {
      type = types.path;
      default = "/var/lib/grav";
      description = ''
        Root of the application.
      '';
    };

    pool = mkOption {
      type = types.str;
      default = "${poolName}";
      description = ''
        Name of existing phpfpm pool that is used to run web-application.
        If not specified a pool will be created automatically with
        default values.
      '';
    };

    virtualHost = mkOption {
      type = types.nullOr types.str;
      default = "grav";
      description = ''
        Name of the nginx virtualhost to use and setup. If null, do not setup
        any virtualhost.
      '';
    };

    phpPackage = mkPackageOption pkgs "php83" { };

    maxUploadSize = mkOption {
      type = types.str;
      default = "128M";
      description = ''
        The upload limit for files. This changes the relevant options in
        {file}`php.ini` and nginx if enabled.
      '';
    };

    systemSettings = mkOption {
      type = yamlFormat.type;
      default = {
        log = {
          handler = "syslog";
        };
      };
      description = ''
        Settings written to {file}`user/config/system.yaml`.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.phpfpm.pools = mkIf (cfg.pool == "${poolName}") {
      ${poolName} = {
        user = "grav";
        group = "grav";

        phpPackage = cfg.phpPackage.buildEnv {
          extensions =
            { all, enabled }:
            enabled
            ++ (with all; [
              apcu
              xml
              yaml
            ]);

          extraConfig = generators.toKeyValue { mkKeyValue = generators.mkKeyValueDefault { } " = "; } {
            output_buffering = "0";
            short_open_tag = "Off";
            expose_php = "Off";
            error_reporting = "E_ALL";
            display_errors = "stderr";
            "opcache.interned_strings_buffer" = "8";
            "opcache.max_accelerated_files" = "10000";
            "opcache.memory_consumption" = "128";
            "opcache.revalidate_freq" = "1";
            "opcache.fast_shutdown" = "1";
            "openssl.cafile" = config.security.pki.caBundle;
            catch_workers_output = "yes";

            upload_max_filesize = cfg.maxUploadSize;
            post_max_size = cfg.maxUploadSize;
            memory_limit = cfg.maxUploadSize;
            "apc.enable_cli" = "1";
          };
        };

        phpEnv = {
          GRAV_ROOT = toString servedRoot;
          GRAV_SYSTEM_PATH = "${servedRoot}/system";
          GRAV_CACHE_PATH = "/var/cache/grav";
          GRAV_BACKUP_PATH = "/var/lib/grav/backup";
          GRAV_LOG_PATH = "/var/log/grav";
          GRAV_TMP_PATH = "/var/tmp/grav";
        };

        settings = mapAttrs (name: mkDefault) {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
          "listen.mode" = "0600";
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 10;
          "pm.min_spare_servers" = 5;
          "pm.max_spare_servers" = 20;
          "pm.max_requests" = 500;
          "catch_workers_output" = 1;
        };
      };
    };

    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      virtualHosts = {
        ${cfg.virtualHost} = {
          root = "${servedRoot}";

          locations = {
            "= /robots.txt" = {
              priority = 100;
              extraConfig = ''
                allow all;
                access_log off;
              '';
            };

            "~ \\.php$" = {
              priority = 200;
              extraConfig = ''
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass unix:${config.services.phpfpm.pools.${cfg.pool}.socket};
                fastcgi_index index.php;
              '';
            };

            "~* /(\\.git|cache|bin|logs|backup|tests)/.*$" = {
              priority = 300;
              extraConfig = ''
                return 403;
              '';
            };

            # deny running scripts inside core system folders
            "~* /(system|vendor)/.*\\.(txt|xml|md|html|htm|shtml|shtm|json|yaml|yml|php|php2|php3|php4|php5|phar|phtml|pl|py|cgi|twig|sh|bat)$" =
              {
                priority = 300;
                extraConfig = ''
                  return 403;
                '';
              };

            # deny running scripts inside user folder
            "~* /user/.*\\.(txt|md|json|yaml|yml|php|php2|php3|php4|php5|phar|phtml|pl|py|cgi|twig|sh|bat)$" = {
              priority = 300;
              extraConfig = ''
                return 403;
              '';
            };

            # deny access to specific files in the root folder
            "~ /(LICENSE\\.txt|composer\\.lock|composer\\.json|nginx\\.conf|web\\.config|htaccess\\.txt|\\.htaccess)" =
              {
                priority = 300;
                extraConfig = ''
                  return 403;
                '';
              };

            # deny all files and folder beginning with a dot (hidden files & folders)
            "~ (^|/)\\." = {
              priority = 300;
              extraConfig = ''
                return 403;
              '';
            };

            "/" = {
              priority = 400;
              index = "index.php";
              extraConfig = ''
                try_files $uri $uri/ /index.php?$query_string;
              '';
            };
          };

          extraConfig = ''
            index index.php index.html /index.php$request_uri;
            add_header X-Content-Type-Options nosniff;
            add_header X-Download-Options noopen;
            add_header X-Permitted-Cross-Domain-Policies none;
            add_header X-Frame-Options sameorigin;
            add_header Referrer-Policy no-referrer;
            client_max_body_size ${cfg.maxUploadSize};
            fastcgi_buffers 64 4K;
            fastcgi_hide_header X-Powered-By;
            gzip on;
            gzip_vary on;
            gzip_comp_level 4;
            gzip_min_length 256;
            gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
            gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
          '';
        };
      };
    };

    systemd.tmpfiles.rules =
      let
        datadir = "/var/lib/grav";
      in
      map (dir: "d '${dir}' 0750 grav grav - -") [
        "/var/cache/grav"
        "${datadir}/assets"
        "${datadir}/backup"
        "${datadir}/images"
        "${datadir}/system/config"
        "${datadir}/user/accounts"
        "${datadir}/user/config"
        "${datadir}/user/data"
        "/var/log/grav"
      ]
      ++ [ "L+ ${datadir}/user/config/system.yaml - - - - ${systemSettingsYaml}" ];

    systemd.services = {
      "phpfpm-${poolName}" = mkIf (cfg.pool == "${poolName}") {
        restartTriggers = [
          servedRoot
          systemSettingsYaml
        ];

        serviceConfig = {
          ExecStartPre = pkgs.writeShellScript "grav-pre-start" ''
            function setPermits() {
              chmod -R o-rx "$1"
              chown -R grav:grav "$1"
            }

            tmpDir=/var/tmp/grav
            dataDir=/var/lib/grav

            mkdir $tmpDir
            setPermits $tmpDir

            for path in config/site.yaml pages plugins themes; do
              fullPath="$dataDir/user/$path"
              if [[ ! -e $fullPath ]]; then
                cp --reflink=auto --no-preserve=mode -r \
                  ${cfg.package}/user/$path $fullPath
              fi
              setPermits $fullPath
            done

            systemConfigDir=$dataDir/system/config
            if [[ ! -e $systemConfigDir/system.yaml ]]; then
              cp --reflink=auto --no-preserve=mode -r \
                ${cfg.package}/system/config/* $systemConfigDir/
            fi
            setPermits $systemConfigDir
          '';
        };
      };
    };

    users.users.grav = {
      isSystemUser = true;
      description = "Grav service user";
      home = "/var/lib/grav";
      group = "grav";
    };

    users.groups.grav = {
      members = [ config.services.nginx.user ];
    };
  };
}
