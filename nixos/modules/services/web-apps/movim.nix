{
  config,
  lib,
  pkgs,
  ...
}:

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

  phpCfg = generators.toKeyValue { mkKeyValue = generators.mkKeyValueDefault { } " = "; } (
    defaultPHPCfg // cfg.phpCfg
  );

  podConfigFlags =
    let
      bevalue = a: lib.escapeShellArg (generators.mkValueStringDefault { } a);
    in
    lib.concatStringsSep " " (
      lib.attrsets.foldlAttrs (
        acc: k: v:
        acc ++ lib.optional (v != null) "--${k}=${bevalue v}"
      ) [ ] cfg.podConfig
    );

  package =
    let
      p = cfg.package.override (
        {
          inherit phpCfg;
          inherit (cfg) minifyStaticFiles;
        }
        // lib.optionalAttrs (cfg.database.type == "postgresql") {
          withPostgreSQL = true;
        }
        // lib.optionalAttrs (cfg.database.type == "mariadb") {
          withMySQL = true;
        }
      );
    in
    p.overrideAttrs (
      finalAttrs: prevAttrs:
      let
        appDir = "$out/share/php/${finalAttrs.pname}";

        stateDirectories = # sh
          ''
            # Symlinking in our state directories
            rm -rf $out/{.env,cache} ${appDir}/{log,public/cache}
            ln -s ${cfg.dataDir}/.env ${appDir}/.env
            ln -s ${cfg.dataDir}/public/cache ${appDir}/public/cache
            ln -s ${cfg.logDir} ${appDir}/log
            ln -s ${cfg.runtimeDir}/cache ${appDir}/cache
          '';

        exposeComposer = # sh
          ''
            # Expose PHP Composer for scripts
            mkdir -p $out/bin
            echo "#!${lib.getExe pkgs.dash}" > $out/bin/movim-composer
            echo "${finalAttrs.php.packages.composer}/bin/composer --working-dir="${appDir}" \"\$@\"" >> $out/bin/movim-composer
            chmod +x $out/bin/movim-composer
          '';

        podConfigInputDisableReplace = lib.optionalString (podConfigFlags != "") (
          lib.concatStringsSep "\n" (
            lib.attrsets.foldlAttrs (
              acc: k: v:
              acc
              ++
                lib.optional (v != null)
                  # Disable all Admin panel options that were set in the
                  # `cfg.podConfig` to prevent confusing situtions where the
                  # values are rewritten on server reboot
                  # sh
                  ''
                    substituteInPlace ${appDir}/app/Widgets/AdminMain/adminmain.tpl \
                      --replace-warn 'name="${k}"' 'name="${k}" readonly'
                  ''
            ) [ ] cfg.podConfig
          )
        );

        precompressStaticFilesJobs =
          let
            inherit (cfg.precompressStaticFiles) brotli gzip;

            findTextFileNames = lib.concatStringsSep " -o " (
              builtins.map (n: ''-iname "*.${n}"'') [
                "css"
                "ini"
                "js"
                "json"
                "manifest"
                "mjs"
                "svg"
                "webmanifest"
              ]
            );
          in
          lib.concatStringsSep "\n" [
            (lib.optionalString brotli.enable # sh
              ''
                echo -n "Precompressing static files with Brotli …"
                find ${appDir}/public -type f ${findTextFileNames} -print0 \
                  | xargs -0 -P$NIX_BUILD_CORES -n1 -I{} \
                      ${lib.getExe brotli.package} --keep --quality=${builtins.toString brotli.compressionLevel} --output={}.br {}
                echo " done."
              ''
            )
            (lib.optionalString gzip.enable # sh
              ''
                echo -n "Precompressing static files with Gzip …"
                find ${appDir}/public -type f ${findTextFileNames} -print0 \
                  | xargs -0 -P$NIX_BUILD_CORES -n1 -I{} \
                      ${lib.getExe gzip.package} -c -${builtins.toString gzip.compressionLevel} {} > {}.gz
                echo " done."
              ''
            )
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
      }
    );

  configFile = pipe cfg.settings [
    (filterAttrsRecursive (_: v: v != null))
    (generators.toKeyValue { })
    (pkgs.writeText "movim-env")
  ];

  pool = "movim";
  fpm = config.services.phpfpm.pools.${pool};
  phpExecutionUnit = "phpfpm-${pool}";

  dbUnit =
    {
      "postgresql" = "postgresql.target";
      "mariadb" = "mysql.service";
    }
    .${cfg.database.type};

  # exclusivity asserted in `assertions`
  webServerService =
    if cfg.h2o != null then
      "h2o.service"
    else if cfg.nginx != null then
      "nginx.service"
    else
      null;

  socketOwner =
    if cfg.h2o != null then
      config.services.h2o.user
    else if cfg.nginx != null then
      config.services.nginx.user
    else
      cfg.user;

  # Movim needs a lot of unsafe values to function at this time. Perhaps if
  # this is ever addressed in the future, the PHP application will send up the
  # proper directive. For now this fairly conservative CSP will restrict a lot
  # of potentially bad stuff as well as take in inventory of the features used.
  #
  # See: https://github.com/movim/movim/issues/314
  movimCSP = lib.concatStringsSep "; " [
    "default-src 'self'"
    "img-src 'self' aesgcm: data: https:"
    "media-src 'self' aesgcm: https:"
    "script-src 'self' 'unsafe-eval' 'unsafe-inline'"
    "style-src 'self' 'unsafe-inline'"
  ];
in
{
  options.services = {
    movim = {
      enable = mkEnableOption "a Movim instance";
      package = mkPackageOption pkgs "movim" { };
      phpPackage = mkPackageOption pkgs "php" { };

      phpCfg = mkOption {
        type =
          with types;
          attrsOf (oneOf [
            int
            str
            bool
          ]);
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
        type = types.path;
        default = "/var/lib/movim";
        description = "State directory of the `movim` user which holds the application’s state & data.";
      };

      logDir = mkOption {
        type = types.path;
        default = "/var/log/movim";
        description = "Log directory of the `movim` user which holds the application’s logs.";
      };

      runtimeDir = mkOption {
        type = types.path;
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
        type = types.either types.bool (
          types.submodule {
            options = {
              script = mkOption {
                type = types.submodule {
                  options = {
                    enable = mkEnableOption "Script minification via esbuild";
                    target = mkOption {
                      type = types.nullOr types.nonEmptyStr;
                      default = null;
                      description = ''
                        esbuild target environment string. If not set, a sane
                        default will be provided. See:
                        <https://esbuild.github.io/api/#target>.
                      '';
                    };
                  };
                };
              };
              style = mkOption {
                type = types.submodule {
                  options = {
                    enable = mkEnableOption "Script minification via Lightning CSS";
                    target = mkOption {
                      type = types.nullOr types.nonEmptyStr;
                      default = null;
                      description = ''
                        Browserslists string target for browser compatibility.
                        If not set, a sane default will be provided. See:
                        <https://browsersl.ist>.
                      '';
                    };
                  };
                };
              };
              svg = mkOption {
                type = types.submodule {
                  options = {
                    enable = mkEnableOption "SVG minification via Scour";
                  };
                };
              };
            };
          }
        );
        default = true;
        description = ''
          Do minification on public static files which reduces the size of
          assets — saving data for the server & users as well as offering a
          performance improvement. This adds typing for the `minifyStaticFiles`
          attribute for the Movim package which *will* override any existing
          override value. The default `true` will enable minification for all
          supported asset types with sane defaults.
        '';
        example =
          lib.literalExpression # nix
            ''
              {
                script.enable = false;
                style = {
                  enable = true;
                  target = "> 0.5%, last 2 versions, Firefox ESR, not dead";
                };
                svg.enable = true;
              }
            '';
      };

      precompressStaticFiles = mkOption {
        type = types.submodule {
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
              type = types.nullOr types.nonEmptyStr;
              default = null;
              description = "Content of the info box on the login page";
            };

            description = mkOption {
              type = types.nullOr types.nonEmptyStr;
              default = null;
              description = "General description of the instance";
            };

            timezone = mkOption {
              type = types.nullOr types.nonEmptyStr;
              default = null;
              description = "The server timezone";
            };

            restrictsuggestions = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Only suggest chatrooms, Communities and other contents that are available on the user XMPP server and related services";
            };

            chatonly = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Disable all the social feature (Communities, Blog…) and keep only the chat ones";
            };

            disableregistration = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Remove the XMPP registration flow and buttons from the interface";
            };

            loglevel = mkOption {
              type = types.nullOr (types.ints.between 0 3);
              default = null;
              description = "The server loglevel";
            };

            locale = mkOption {
              type = types.nullOr types.nonEmptyStr;
              default = null;
              description = "The server main locale";
            };

            xmppdomain = mkOption {
              type = types.nullOr types.nonEmptyStr;
              default = null;
              description = "The default XMPP server domain";
            };

            xmppdescription = mkOption {
              type = types.nullOr types.nonEmptyStr;
              default = null;
              description = "The default XMPP server description";
            };

            xmppwhitelist = mkOption {
              type = types.nullOr types.nonEmptyStr;
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
        type =
          with types;
          attrsOf (
            nullOr (oneOf [
              int
              str
              bool
            ])
          );
        default = { };
        description = ".env settings for Movim. Secrets should use `secretFile` option instead. `null`s will be culled.";
      };

      secretFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "The secret file to be sourced for the .env settings.";
      };

      database = {
        type = mkOption {
          type = types.enum [
            "mariadb"
            "postgresql"
          ];
          example = "mariadb";
          default = "postgresql";
          description = "Database engine to use.";
        };

        name = mkOption {
          type = types.nonEmptyStr;
          default = "movim";
          description = "Database name.";
        };

        user = mkOption {
          type = types.nonEmptyStr;
          default = "movim";
          description = "Database username.";
        };

        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = "local database using UNIX socket authentication";
        };
      };

      h2o = mkOption {
        type = types.nullOr (
          types.submodule (import ../web-servers/h2o/vhost-options.nix { inherit config lib; })
        );
        default = null;
        example =
          lib.literalExpression # nix
            ''
              {
                serverAliases = [
                  "pics.''${config.movim.domain}"
                ];
                acme.enable = true;
                tls.policy = "force";
              }
            '';
        description = ''
          With this option, you can customize an H2O virtual host which already
          has sensible defaults for Movim. Set to `{ }` if you do not need any
          customization to the virtual host. If enabled, then by default, the
          {option}`serverName` is `''${domain}`, If this is set to `null` (the
          default), no H2O `hosts` will be configured.
        '';
      };

      nginx = mkOption {
        type = types.nullOr (
          types.submodule (import ../web-servers/nginx/vhost-options.nix { inherit config lib; })
        );
        default = null;
        example =
          lib.literalExpression # nix
            ''
              {
                serverAliases = [
                  "pics.''${config.movim.domain}"
                ];
                enableACME = true;
                forceHttps = true;
              }
            '';
        description = ''
          With this option, you can customize an Nginx virtual host which
          already has sensible defaults for Movim. Set to `{ }` if you do not
          need any customization to the virtual host. If enabled, then by
          default, the {option}`serverName` is `''${domain}`, If this is set to
          `null` (the default), no Nginx `virtualHost` will be configured.
        '';
      };

      poolConfig = mkOption {
        type =
          with types;
          attrsOf (oneOf [
            int
            str
            bool
          ]);
        default = { };
        description = "Options for Movim’s PHP-FPM pool.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (
        let
          webServers = [
            "h2o"
            "nginx"
          ];
          checkConfigs = lib.concatMapStringsSep ", " (ws: "services.movim.${ws}") webServers;
        in
        {
          assertion = builtins.length (lib.lists.filter (ws: cfg.${ws} != null) webServers) <= 1;
          message = ''
            At most 1 web server virtual host configuration should be enabled
            for Movim at a time. Check ${checkConfigs}.
          '';
        }
      )
    ];

    environment.systemPackages = [ package ];

    users = {
      users = {
        movim = mkIf (cfg.user == "movim") {
          isSystemUser = true;
          group = cfg.group;
        };
      }
      // lib.optionalAttrs (cfg.h2o != null) {
        "${config.services.h2o.user}".extraGroups = [ cfg.group ];
      }
      // lib.optionalAttrs (cfg.nginx != null) {
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
            DB_DRIVER =
              {
                "postgresql" = "pgsql";
                "mariadb" = "mysql";
              }
              .${cfg.database.type};
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

      h2o = mkIf (cfg.h2o != null) {
        enable = true;
        hosts."${cfg.domain}" = mkMerge [
          {
            settings = {
              paths = {
                "/ws/" = {
                  "proxy.preserve-host" = "ON";
                  "proxy.tunnel" = "ON";
                  "proxy.reverse.url" = "http://${cfg.settings.DAEMON_INTERFACE}:${builtins.toString cfg.port}/";
                };
                "/" = {
                  "file.dir" = "${package}/share/php/movim/public";
                  "file.index" = [
                    "index.php"
                    "index.html"
                  ];
                  redirect = {
                    url = "/index.php/";
                    internal = "YES";
                    status = 307;
                  };
                  "header.set" = [
                    "Content-Security-Policy: ${movimCSP}"
                  ];
                }
                // lib.optionalAttrs (with cfg.precompressStaticFiles; brotli.enable || gzip.enable) {
                  "file.send-compressed" = "ON";
                };
              };
              "file.custom-handler" = {
                extension = [ ".php" ];
                "fastcgi.document_root" = package;
                "fastcgi.connect" = {
                  port = fpm.socket;
                  type = "unix";
                };
              };
            };
          }
          cfg.h2o
        ];
      };

      nginx = mkIf (cfg.nginx != null) (
        {
          enable = true;
          recommendedOptimisation = mkDefault true;
          recommendedProxySettings = true;
          # TODO: recommended cache options already in Nginx⁇
          appendHttpConfig = # nginx
            ''
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
                  extraConfig = # nginx
                    ''
                      access_log off;
                      log_not_found off;
                    '';
                };
                "/robots.txt" = {
                  priority = 100;
                  extraConfig = # nginx
                    ''
                      access_log off;
                      log_not_found off;
                    '';
                };
                "~ /\\.(?!well-known).*" = {
                  priority = 210;
                  extraConfig = # nginx
                    ''
                      deny all;
                    '';
                };
                # Ask nginx to cache every URL starting with "/picture"
                "/picture" = {
                  priority = 400;
                  tryFiles = "$uri $uri/ /index.php$is_args$args";
                  extraConfig = # nginx
                    ''
                      set $no_cache 0; # Enable cache only there
                    '';
                };
                "/" = {
                  priority = 490;
                  tryFiles = "$uri $uri/ /index.php$is_args$args";
                  extraConfig = # nginx
                    ''
                      add_header Content-Security-Policy "${movimCSP}";
                      set $no_cache 1;
                    '';
                };
                "~ \\.php$" = {
                  priority = 500;
                  tryFiles = "$uri =404";
                  extraConfig = # nginx
                    ''
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
                  extraConfig = # nginx
                    ''
                      proxy_set_header X-Forwarded-Proto $scheme;
                      proxy_redirect off;
                    '';
                };
              };
              extraConfig = # nginx
                ''
                  index index.php;
                '';
            }
          ];
        }
        // lib.optionalAttrs (cfg.precompressStaticFiles.gzip.enable) {
          recommendedGzipSettings = mkDefault true;
        }
        // lib.optionalAttrs (cfg.precompressStaticFiles.brotli.enable) {
          recommendedBrotliSettings = mkDefault true;
        }
      );

      mysql = mkIf (cfg.database.createLocally && cfg.database.type == "mariadb") {
        enable = mkDefault true;
        package = mkDefault pkgs.mariadb;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          {
            name = cfg.database.user;
            ensureDBOwnership = true;
          }
        ];
      };

      postgresql = mkIf (cfg.database.createLocally && cfg.database.type == "postgresql") {
        enable = mkDefault true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          {
            name = cfg.database.user;
            ensureDBOwnership = true;
          }
        ];
        authentication = ''
          host ${cfg.database.name} ${cfg.database.user} localhost trust
        '';
      };

      phpfpm.pools.${pool} = {
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
        }
        // cfg.poolConfig;
      };
    };

    systemd = {
      services.movim-data-setup = {
        description = "Movim setup: .env file, databases init, cache reload";
        wantedBy = [ "multi-user.target" ];
        requiredBy = [ "${phpExecutionUnit}.service" ];
        before = [ "${phpExecutionUnit}.service" ];
        wants = [ "local-fs.target" ];
        requires = lib.optional cfg.database.createLocally dbUnit;
        after = lib.optional cfg.database.createLocally dbUnit;

        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
          Group = cfg.group;
          UMask = "077";
        }
        // lib.optionalAttrs (cfg.secretFile != null) {
          LoadCredential = "env-secrets:${cfg.secretFile}";
        };

        script = # sh
        ''
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
            flags = lib.concatStringsSep " " (
              [ "--no-interaction" ]
              ++ lib.optional cfg.debug "-vvv"
              ++ lib.optional (!cfg.debug && cfg.verbose) "-v"
            );
          in
          ''
            ${lib.getExe package} config ${podConfigFlags}
          ''
        );
      };

      services.${phpExecutionUnit} = {
        wantedBy = lib.optional (webServerService != null) webServerService;
        requiredBy = [ "movim.service" ];
        before = [ "movim.service" ] ++ lib.optional (webServerService != null) webServerService;
        wants = [ "network.target" ];
        requires = [ "movim-data-setup.service" ] ++ lib.optional cfg.database.createLocally dbUnit;
        after = [ "movim-data-setup.service" ] ++ lib.optional cfg.database.createLocally dbUnit;
      };

      services.movim = {
        description = "Movim daemon";
        wantedBy = [ "multi-user.target" ];
        wants = [
          "network.target"
          "local-fs.target"
        ];
        requires = [
          "movim-data-setup.service"
          "${phpExecutionUnit}.service"
        ]
        ++ lib.optional cfg.database.createLocally dbUnit
        ++ lib.optional (webServerService != null) webServerService;
        after = [
          "movim-data-setup.service"
          "${phpExecutionUnit}.service"
        ]
        ++ lib.optional cfg.database.createLocally dbUnit
        ++ lib.optional (webServerService != null) webServerService;
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

      tmpfiles.settings."10-movim" = with cfg; {
        "${dataDir}".d = {
          inherit user group;
          mode = "0710";
        };
        "${dataDir}/public".d = {
          inherit user group;
          mode = "0750";
        };
        "${dataDir}/public/cache".d = {
          inherit user group;
          mode = "0750";
        };
        "${runtimeDir}".d = {
          inherit user group;
          mode = "0700";
        };
        "${runtimeDir}/cache".d = {
          inherit user group;
          mode = "0700";
        };
        "${logDir}".d = {
          inherit user group;
          mode = "0700";
        };
      };
    };
  };

  imports = [
    (lib.mkRemovedOptionModule [ "minifyStaticFiles" "script" "package" ] ''
      Override services.movim.package instead.
    '')
    (lib.mkRemovedOptionModule [ "minifyStaticFiles" "style" "package" ] ''
      Override services.movim.package instead.
    '')
    (lib.mkRemovedOptionModule [ "minifyStaticFiles" "svg" "package" ] ''
      Override services.movim.package instead.
    '')
  ];
}
