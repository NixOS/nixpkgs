{ config, lib, pkgs, ... }:

let
  inherit (lib)
    filterAttrsRecursive
    generators
    literalExpression
    mkDefault
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    mkMerge
    pipe
    types
    ;

  cfg = config.services.movim;

  defaultPHPCfg = {
    "output_buffering" = 0;
    "error_reporting" = "E_ALL & ~E_DEPRECATED & ~E_STRICT";
    "opcache.enable_cli" = 1;
    "opcache.interned_strings_buffer" = 8;
    "opcache.max_accelerated_files" = 6144;
    "opcache.memory_consumption" = 128;
    "opcache.revalidate_freq" = 2;
    "opcache.fast_shutdown" = 1;
  };

  phpCfg = generators.toKeyValue
    { mkKeyValue = generators.mkKeyValueDefault { } " = "; }
    (defaultPHPCfg // cfg.phpCfg);

  podConfigFlags =
    let
      bevalue = a: lib.escapeShellArg (generators.mkValueStringDefault { } a);
    in
    lib.concatStringsSep " "
      (lib.attrsets.foldlAttrs
        (acc: k: v: acc ++ lib.optional (v != null) "--${k}=${bevalue v}")
        [ ]
        cfg.podConfig);

  package =
    let
      p = cfg.package.override
        ({
          inherit phpCfg;
          withPgsql = cfg.database.type == "pgsql";
          withMysql = cfg.database.type == "mysql";
          inherit (cfg) minifyStaticFiles;
        } // lib.optionalAttrs (lib.isAttrs cfg.minifyStaticFiles) (with cfg.minifyStaticFiles; {
          esbuild = esbuild.package;
          lightningcss = lightningcss.package;
          scour = scour.package;
        }));
    in
    p.overrideAttrs (finalAttrs: prevAttrs:
      let
        appDir = "$out/share/php/${finalAttrs.pname}";

        stateDirectories = ''
          # Symlinking in our state directories
          rm -rf $out/.env $out/cache ${appDir}/public/cache
          ln -s ${cfg.dataDir}/.env ${appDir}/.env
          ln -s ${cfg.dataDir}/public/cache ${appDir}/public/cache
          ln -s ${cfg.logDir} ${appDir}/log
          ln -s ${cfg.runtimeDir}/cache ${appDir}/cache
        '';

        exposeComposer = ''
          # Expose PHP Composer for scripts
          mkdir -p $out/bin
          echo "#!${lib.getExe pkgs.dash}" > $out/bin/movim-composer
          echo "${finalAttrs.php.packages.composer}/bin/composer --working-dir="${appDir}" \"\$@\"" >> $out/bin/movim-composer
          chmod +x $out/bin/movim-composer
        '';

        podConfigInputDisableReplace = lib.optionalString (podConfigFlags != "")
          (lib.concatStringsSep "\n"
            (lib.attrsets.foldlAttrs
              (acc: k: v:
                acc ++ lib.optional (v != null)
                  # Disable all Admin panel options that were set in the
                  # `cfg.podConfig` to prevent confusing situtions where the
                  # values are rewritten on server reboot
                  ''
                    substituteInPlace ${appDir}/app/widgets/AdminMain/adminmain.tpl \
                      --replace-warn 'name="${k}"' 'name="${k}" disabled'
                  '')
              [ ]
              cfg.podConfig));

        precompressStaticFilesJobs =
          let
            inherit (cfg.precompressStaticFiles) brotli gzip;

            findTextFileNames = lib.concatStringsSep " -o "
              (builtins.map (n: ''-iname "*.${n}"'')
                [ "css" "ini" "js" "json" "manifest" "mjs" "svg" "webmanifest" ]);
          in
          lib.concatStringsSep "\n" [
            (lib.optionalString brotli.enable ''
              echo -n "Precompressing static files with Brotli …"
              find ${appDir}/public -type f ${findTextFileNames} -print0 \
                | xargs -0 -n 1 -P $NIX_BUILD_CORES ${pkgs.writeShellScript "movim_precompress_broti" ''
                    file="$1"
                    ${lib.getExe brotli.package} --keep --quality=${builtins.toString brotli.compressionLevel} --output=$file.br $file
                  ''}
              echo " done."
            '')
            (lib.optionalString gzip.enable ''
              echo -n "Precompressing static files with Gzip …"
              find ${appDir}/public -type f ${findTextFileNames} -print0 \
                | xargs -0 -n 1 -P $NIX_BUILD_CORES ${pkgs.writeShellScript "movim_precompress_broti" ''
                    file="$1"
                    ${lib.getExe gzip.package} -c -${builtins.toString gzip.compressionLevel} $file > $file.gz
                  ''}
              echo " done."
            '')
          ];
      in
      {
        postInstall = lib.concatStringsSep "\n\n" [
          prevAttrs.postInstall
          stateDirectories
          exposeComposer
          podConfigInputDisableReplace
          precompressStaticFilesJobs
        ];
      });

  configFile = pipe cfg.settings [
    (filterAttrsRecursive (_: v: v != null))
    (generators.toKeyValue { })
    (pkgs.writeText "movim-env")
  ];

  pool = "movim";
  fpm = config.services.phpfpm.pools.${pool};
  phpExecutionUnit = "phpfpm-${pool}";

  dbService = {
    "postgresql" = "postgresql.service";
    "mysql" = "mysql.service";
  }.${cfg.database.type};
in
{
  options.services = {
    movim = {
      enable = mkEnableOption "a Movim instance";
      package = mkPackageOption pkgs "movim" { };
      phpPackage = mkPackageOption pkgs "php" { };

      phpCfg = mkOption {
        type = with types; attrsOf (oneOf [ int str bool ]);
        defaultText = literalExpression (generators.toPretty { } defaultPHPCfg);
        default = { };
        description = "Extra PHP INI options such as `memory_limit`, `max_execution_time`, etc.";
      };

      user = mkOption {
        type = types.nonEmptyStr;
        default = "movim";
        description = "User running Movim service";
      };

      group = mkOption {
        type = types.nonEmptyStr;
        default = "movim";
        description = "Group running Movim service";
      };

      dataDir = mkOption {
        type = types.nonEmptyStr;
        default = "/var/lib/movim";
        description = "State directory of the `movim` user which holds the application’s state & data.";
      };

      logDir = mkOption {
        type = types.nonEmptyStr;
        default = "/var/log/movim";
        description = "Log directory of the `movim` user which holds the application’s logs.";
      };

      runtimeDir = mkOption {
        type = types.nonEmptyStr;
        default = "/run/movim";
        description = "Runtime directory of the `movim` user which holds the application’s caches & temporary files.";
      };

      domain = mkOption {
        type = types.nonEmptyStr;
        description = "Fully-qualified domain name (FQDN) for the Movim instance.";
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = "Movim daemon port.";
      };

      debug = mkOption {
        type = types.bool;
        default = false;
        description = "Debugging logs.";
      };

      verbose = mkOption {
        type = types.bool;
        default = false;
        description = "Verbose logs.";
      };

      minifyStaticFiles = mkOption {
        type = with types; either bool (submodule {
          options = {
            script = mkOption {
              type = types.submodule {
                options = {
                  enable = mkEnableOption "Script minification";
                  package = mkPackageOption pkgs "esbuild" { };
                  target = mkOption {
                    type = with types; nullOr nonEmptyStr;
                    default = null;
                  };
                };
              };
            };
            style = mkOption {
              type = types.submodule {
                options = {
                  enable = mkEnableOption "Script minification";
                  package = mkPackageOption pkgs "lightningcss" { };
                  target = mkOption {
                    type = with types; nullOr nonEmptyStr;
                    default = null;
                  };
                };
              };
            };
            svg = mkOption {
              type = types.submodule {
                options = {
                  enable = mkEnableOption "SVG minification";
                  package = mkPackageOption pkgs "scour" { };
                };
              };
            };
          };
        });
        default = true;
        description = "Do minification on public static files";
      };

      precompressStaticFiles = mkOption {
        type = with types; submodule {
          options = {
            brotli = {
              enable = mkEnableOption "Brotli precompression";
              package = mkPackageOption pkgs "brotli" { };
              compressionLevel = mkOption {
                type = types.ints.between 0 11;
                default = 11;
                description = "Brotli compression level";
              };
            };
            gzip = {
              enable = mkEnableOption "Gzip precompression";
              package = mkPackageOption pkgs "gzip" { };
              compressionLevel = mkOption {
                type = types.ints.between 1 9;
                default = 9;
                description = "Gzip compression level";
              };
            };
          };
        };
        default = {
          brotli.enable = true;
          gzip.enable = false;
        };
        description = "Aggressively precompress static files";
      };

      podConfig = mkOption {
        type = types.submodule {
          options = {
            info = mkOption {
              type = with types; nullOr str;
              default = null;
              description = "Content of the info box on the login page";
            };

            description = mkOption {
              type = with types; nullOr str;
              default = null;
              description = "General description of the instance";
            };

            timezone = mkOption {
              type = with types; nullOr str;
              default = null;
              description = "The server timezone";
            };

            restrictsuggestions = mkOption {
              type = with types; nullOr bool;
              default = null;
              description = "Only suggest chatrooms, Communities and other contents that are available on the user XMPP server and related services";
            };

            chatonly = mkOption {
              type = with types; nullOr bool;
              default = null;
              description = "Disable all the social feature (Communities, Blog…) and keep only the chat ones";
            };

            disableregistration = mkOption {
              type = with types; nullOr bool;
              default = null;
              description = "Remove the XMPP registration flow and buttons from the interface";
            };

            loglevel = mkOption {
              type = with types; nullOr (ints.between 0 3);
              default = null;
              description = "The server loglevel";
            };

            locale = mkOption {
              type = with types; nullOr str;
              default = null;
              description = "The server main locale";
            };

            xmppdomain = mkOption {
              type = with types; nullOr str;
              default = null;
              description = "The default XMPP server domain";
            };

            xmppdescription = mkOption {
              type = with types; nullOr str;
              default = null;
              description = "The default XMPP server description";
            };

            xmppwhitelist = mkOption {
              type = with types; nullOr str;
              default = null;
              description = "The allowlisted XMPP servers";
            };
          };
        };
        default = { };
        description = ''
          Pod configuration (values from `php daemon.php config --help`).
          Note that these values will now be disabled in the admin panel.
        '';
      };

      settings = mkOption {
        type = with types; attrsOf (nullOr (oneOf [ int str bool ]));
        default = { };
        description = ".env settings for Movim. Secrets should use `secretFile` option instead. `null`s will be culled.";
      };

      secretFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = "The secret file to be sourced for the .env settings.";
      };

      database = {
        type = mkOption {
          type = types.enum [ "mysql" "postgresql" ];
          example = "mysql";
          default = "postgresql";
          description = "Database engine to use.";
        };

        name = mkOption {
          type = types.str;
          default = "movim";
          description = "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "movim";
          description = "Database username.";
        };

        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = "local database using UNIX socket authentication";
        };
      };

      nginx = mkOption {
        type = with types; nullOr (submodule
          (import ../web-servers/nginx/vhost-options.nix {
            inherit config lib;
          }));
        default = null;
        example = lib.literalExpression /* nginx */ ''
          {
            serverAliases = [
              "pics.''${config.networking.domain}"
            ];
            enableACME = true;
            forceHttps = true;
          }
        '';
        description = ''
          With this option, you can customize an nginx virtual host which already has sensible defaults for Movim.
          Set to `{ }` if you do not need any customization to the virtual host.
          If enabled, then by default, the {option}`serverName` is `''${domain}`,
          If this is set to null (the default), no nginx virtualHost will be configured.
        '';
      };

      poolConfig = mkOption {
        type = with types; attrsOf (oneOf [ int str bool ]);
        default = { };
        description = "Options for Movim’s PHP-FPM pool.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users = {
      users = {
        movim = mkIf (cfg.user == "movim") {
          isSystemUser = true;
          group = cfg.group;
        };
        "${config.services.nginx.user}".extraGroups = [ cfg.group ];
      };
      groups = {
        ${cfg.group} = { };
      };
    };

    services = {
      movim = {
        settings = mkMerge [
          {
            DAEMON_URL = "//${cfg.domain}";
            DAEMON_PORT = cfg.port;
            DAEMON_INTERFACE = "127.0.0.1";
            DAEMON_DEBUG = cfg.debug;
            DAEMON_VERBOSE = cfg.verbose;
          }
          (mkIf cfg.database.createLocally {
            DB_DRIVER = {
              "postgresql" = "pgsql";
              "mysql" = "mysql";
            }.${cfg.database.type};
            DB_HOST = "localhost";
            DB_PORT = config.services.${cfg.database.type}.settings.port;
            DB_DATABASE = cfg.database.name;
            DB_USERNAME = cfg.database.user;
            DB_PASSWORD = "";
          })
        ];

        poolConfig = lib.mapAttrs' (n: v: lib.nameValuePair n (lib.mkDefault v)) {
          "pm" = "dynamic";
          "php_admin_value[error_log]" = "stderr";
          "php_admin_flag[log_errors]" = true;
          "catch_workers_output" = true;
          "pm.max_children" = 32;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 2;
          "pm.max_spare_servers" = 8;
          "pm.max_requests" = 500;
        };
      };

      nginx = mkIf (cfg.nginx != null) {
        enable = true;
        recommendedOptimisation = true;
        recommendedGzipSettings = true;
        recommendedBrotliSettings = true;
        recommendedProxySettings = true;
        # TODO: recommended cache options already in Nginx⁇
        appendHttpConfig = /* nginx */ ''
          fastcgi_cache_path /tmp/nginx_cache levels=1:2 keys_zone=nginx_cache:100m inactive=60m;
          fastcgi_cache_key "$scheme$request_method$host$request_uri";
        '';
        virtualHosts."${cfg.domain}" = mkMerge [
          cfg.nginx
          {
            root = lib.mkForce "${package}/share/php/movim/public";
            locations = {
              "/favicon.ico" = {
                priority = 100;
                extraConfig = /* nginx */ ''
                  access_log off;
                  log_not_found off;
                '';
              };
              "/robots.txt" = {
                priority = 100;
                extraConfig = /* nginx */ ''
                  access_log off;
                  log_not_found off;
                '';
              };
              "~ /\\.(?!well-known).*" = {
                priority = 210;
                extraConfig = /* nginx */ ''
                  deny all;
                '';
              };
              # Ask nginx to cache every URL starting with "/picture"
              "/picture" = {
                priority = 400;
                tryFiles = "$uri $uri/ /index.php$is_args$args";
                extraConfig = /* nginx */ ''
                  set $no_cache 0; # Enable cache only there
                '';
              };
              "/" = {
                priority = 490;
                tryFiles = "$uri $uri/ /index.php$is_args$args";
                extraConfig = /* nginx */ ''
                  # https://github.com/movim/movim/issues/314
                  add_header Content-Security-Policy "default-src 'self'; img-src 'self' aesgcm: https:; media-src 'self' aesgcm: https:; script-src 'self' 'unsafe-eval' 'unsafe-inline'; style-src 'self' 'unsafe-inline';";
                  set $no_cache 1;
                '';
              };
              "~ \\.php$" = {
                priority = 500;
                tryFiles = "$uri =404";
                extraConfig = /* nginx */ ''
                  include ${config.services.nginx.package}/conf/fastcgi.conf;
                  add_header X-Cache $upstream_cache_status;
                  fastcgi_ignore_headers "Cache-Control" "Expires" "Set-Cookie";
                  fastcgi_cache nginx_cache;
                  fastcgi_cache_valid any 7d;
                  fastcgi_cache_bypass $no_cache;
                  fastcgi_no_cache $no_cache;
                  fastcgi_split_path_info ^(.+\.php)(/.+)$;
                  fastcgi_index index.php;
                  fastcgi_pass unix:${fpm.socket};
                '';
              };
              "/ws/" = {
                priority = 900;
                proxyPass = "http://${cfg.settings.DAEMON_INTERFACE}:${builtins.toString cfg.port}/";
                proxyWebsockets = true;
                recommendedProxySettings = true;
                extraConfig = /* nginx */ ''
                  proxy_set_header X-Forwarded-Proto $scheme;
                  proxy_redirect off;
                '';
              };
            };
            extraConfig = /* ngnix */ ''
              index index.php;
            '';
          }
        ];
      };

      mysql = mkIf (cfg.database.createLocally && cfg.database.type == "mysql") {
        enable = mkDefault true;
        package = mkDefault pkgs.mariadb;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [{
          name = cfg.user;
          ensureDBOwnership = true;
        }];
      };

      postgresql = mkIf (cfg.database.createLocally && cfg.database.type == "postgresql") {
        enable = mkDefault true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [{
          name = cfg.user;
          ensureDBOwnership = true;
        }];
        authentication = ''
          host ${cfg.database.name} ${cfg.database.user} localhost trust
        '';
      };

      phpfpm.pools.${pool} =
        let
          socketOwner =
            if (cfg.nginx != null)
            then config.services.nginx.user
            else cfg.user;
        in
        {
          phpPackage = package.php;
          user = cfg.user;
          group = cfg.group;

          phpOptions = ''
            error_log = 'stderr'
            log_errors = on
          '';

          settings = {
            "listen.owner" = socketOwner;
            "listen.group" = cfg.group;
            "listen.mode" = "0660";
            "catch_workers_output" = true;
          } // cfg.poolConfig;
        };
    };

    systemd = {
      services.movim-data-setup = {
        description = "Movim setup: .env file, databases init, cache reload";
        wantedBy = [ "multi-user.target" ];
        requiredBy = [ "${phpExecutionUnit}.service" ];
        before = [ "${phpExecutionUnit}.service" ];
        after = lib.optional cfg.database.createLocally dbService;
        requires = lib.optional cfg.database.createLocally dbService;

        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
          Group = cfg.group;
          UMask = "077";
        } // lib.optionalAttrs (cfg.secretFile != null) {
          LoadCredential = "env-secrets:${cfg.secretFile}";
        };

        script = ''
          # Env vars
          rm -f ${cfg.dataDir}/.env
          cp --no-preserve=all ${configFile} ${cfg.dataDir}/.env
          echo -e '\n' >> ${cfg.dataDir}/.env
          if [[ -f "$CREDENTIALS_DIRECTORY/env-secrets"  ]]; then
            cat "$CREDENTIALS_DIRECTORY/env-secrets" >> ${cfg.dataDir}/.env
            echo -e '\n' >> ${cfg.dataDir}/.env
          fi

          # Caches, logs
          mkdir -p ${cfg.dataDir}/public/cache ${cfg.logDir} ${cfg.runtimeDir}/cache
          chmod -R ug+rw ${cfg.dataDir}/public/cache
          chmod -R ug+rw ${cfg.logDir}
          chmod -R ug+rwx ${cfg.runtimeDir}/cache

          # Migrations
          MOVIM_VERSION="${package.version}"
          if [[ ! -f "${cfg.dataDir}/.migration-version" ]] || [[ "$MOVIM_VERSION" != "$(<${cfg.dataDir}/.migration-version)" ]]; then
            ${package}/bin/movim-composer movim:migrate && echo $MOVIM_VERSION > ${cfg.dataDir}/.migration-version
          fi
        ''
        + lib.optionalString (podConfigFlags != "") (
          let
            flags = lib.concatStringsSep " "
              ([ "--no-interaction" ]
                ++ lib.optional cfg.debug "-vvv"
                ++ lib.optional (!cfg.debug && cfg.verbose) "-v");
          in
          ''
            ${lib.getExe package} config ${podConfigFlags}
          ''
        );
      };

      services.movim = {
        description = "Movim daemon";
        wantedBy = [ "multi-user.target" ];
        after = [ "movim-data-setup.service" ];
        requires = [ "movim-data-setup.service" ]
          ++ lib.optional cfg.database.createLocally dbService;
        environment = {
          PUBLIC_URL = "//${cfg.domain}";
          WS_PORT = builtins.toString cfg.port;
        };

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = "${package}/share/php/movim";
          ExecStart = "${lib.getExe package} start";
        };
      };

      services.${phpExecutionUnit} = {
        after = [ "movim-data-setup.service" ];
        requires = [ "movim-data-setup.service" ]
          ++ lib.optional cfg.database.createLocally dbService;
      };

      tmpfiles.settings."10-movim" = with cfg; {
        "${dataDir}".d = { inherit user group; mode = "0710"; };
        "${dataDir}/public".d = { inherit user group; mode = "0750"; };
        "${dataDir}/public/cache".d = { inherit user group; mode = "0750"; };
        "${runtimeDir}".d = { inherit user group; mode = "0700"; };
        "${runtimeDir}/cache".d = { inherit user group; mode = "0700"; };
        "${logDir}".d = { inherit user group; mode = "0700"; };
      };
    };
  };
}
