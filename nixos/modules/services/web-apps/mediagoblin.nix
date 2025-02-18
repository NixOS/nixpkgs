{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.mediagoblin;

  mkSubSectionKeyValue =
    depth: k: v:
    if lib.isAttrs v then
      let
        inherit (lib.strings) replicate;
      in
      "${replicate depth "["}${k}${replicate depth "]"}\n"
      + lib.generators.toINIWithGlobalSection {
        mkKeyValue = mkSubSectionKeyValue (depth + 1);
      } { globalSection = v; }
    else
      lib.generators.mkKeyValueDefault {
        mkValueString = v: if lib.isString v then ''"${v}"'' else lib.generators.mkValueStringDefault { } v;
      } " = " k v;

  iniFormat = pkgs.formats.ini { };

  # we need to build our own GI_TYPELIB_PATH because celery and paster need this information, too and cannot easily be re-wrapped
  GI_TYPELIB_PATH =
    let
      needsGst =
        (cfg.settings.mediagoblin.plugins ? "mediagoblin.media_types.audio")
        || (cfg.settings.mediagoblin.plugins ? "mediagoblin.media_types.video");
    in
    lib.makeSearchPathOutput "out" "lib/girepository-1.0" (
      with pkgs.gst_all_1;
      [
        pkgs.glib
        gst-plugins-base
        gstreamer
      ]
      # audio and video share most dependencies, so we can just take audio
      ++ lib.optionals needsGst cfg.package.optional-dependencies.audio
    );

  finalPackage = cfg.package.python.buildEnv.override {
    extraLibs =
      with cfg.package.python.pkgs;
      [
        (toPythonModule cfg.package)
      ]
      ++ cfg.pluginPackages
      # not documented in extras...
      ++ lib.optional (lib.hasPrefix "postgresql://" cfg.settings.mediagoblin.sql_engine) psycopg2
      ++ (
        let
          inherit (cfg.settings.mediagoblin) plugins;
        in
        with cfg.package.optional-dependencies;
        lib.optionals (plugins ? "mediagoblin.media_types.audio") audio
        ++ lib.optionals (plugins ? "mediagoblin.media_types.video") video
        ++ lib.optionals (plugins ? "mediagoblin.media_types.raw_image") raw_image
        ++ lib.optionals (plugins ? "mediagoblin.media_types.ascii") ascii
        ++ lib.optionals (plugins ? "mediagoblin.plugins.ldap") ldap
      );
  };
in
{
  options = {
    services.mediagoblin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable MediaGoblin.

          After the initial deployment, make sure to add an admin account:
          ```
          mediagoblin-gmg adduser --username admin --email admin@example.com
          mediagoblin-gmg makeadmin admin
          ```
        '';
      };

      domain = lib.mkOption {
        type = lib.types.str;
        example = "mediagoblin.example.com";
        description = "Domain under which mediagoblin will be served.";
      };

      createDatabaseLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Whether to configure a local postgres database and connect to it.";
      };

      package = lib.mkPackageOption pkgs "mediagoblin" { };

      pluginPackages = lib.mkOption {
        type = with lib.types; listOf package;
        default = [ ];
        description = "Plugins to add to the environment of MediaGoblin. They still need to be enabled in the config.";
      };

      settings = lib.mkOption {
        description = "Settings which are written into `mediagoblin.ini`.";
        default = { };
        type = lib.types.submodule {
          freeformType = lib.types.anything;

          options = {
            mediagoblin = {
              allow_registration = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Whether to enable user self registration. This is generally not recommend due to spammers.
                  See [upstream FAQ](https://docs.mediagoblin.org/en/stable/siteadmin/production-deployments.html#should-i-keep-open-registration-enabled).
                '';
              };

              email_debug_mode = lib.mkOption {
                type = lib.types.bool;
                default = true;
                example = false;
                description = ''
                  Disable email debug mode to start sending outgoing mails.
                  This requires configuring SMTP settings,
                  see the [upstream docs](https://docs.mediagoblin.org/en/stable/siteadmin/configuration.html#enabling-email-notifications)
                  for details.
                '';
              };

              email_sender_address = lib.mkOption {
                type = lib.types.str;
                example = "noreply@example.org";
                description = "Email address which notices are sent from.";
              };

              sql_engine = lib.mkOption {
                type = lib.types.str;
                default = "sqlite:///var/lib/mediagoblin/mediagoblin.db";
                example = "postgresql:///mediagoblin";
                description = "Database to use.";
              };

              plugins = lib.mkOption {
                defaultText = ''
                  {
                    "mediagoblin.plugins.geolocation" = { };
                    "mediagoblin.plugins.processing_info" = { };
                    "mediagoblin.plugins.basic_auth" = { };
                    "mediagoblin.media_types.image" = { };
                  }
                '';
                description = ''
                  Plugins to enable. See [upstream docs](https://docs.mediagoblin.org/en/stable/siteadmin/plugins.html) for details.
                  Extra dependencies are automatically enabled.
                '';
              };
            };
          };
        };
      };

      paste = {
        port = lib.mkOption {
          type = lib.types.port;
          default = 6543;
          description = "Port under which paste will listen.";
        };

        settings = lib.mkOption {
          description = "Settings which are written into `paste.ini`.";
          default = { };
          type = lib.types.submodule {
            freeformType = iniFormat.type;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "mediagoblin-gmg" ''
        sudo=exec
        if [[ "$USER" != mediagoblin ]]; then
         sudo='exec /run/wrappers/bin/sudo -u mediagoblin'
        fi
        $sudo sh -c "cd /var/lib/mediagoblin; env GI_TYPELIB_PATH=${GI_TYPELIB_PATH} ${lib.getExe' finalPackage "gmg"} $@"
      '')
    ];

    services = {
      mediagoblin.settings.mediagoblin = {
        plugins = {
          "mediagoblin.media_types.image" = { };
          "mediagoblin.plugins.basic_auth" = { };
          "mediagoblin.plugins.geolocation" = { };
          "mediagoblin.plugins.processing_info" = { };
        };
        sql_engine = lib.mkIf cfg.createDatabaseLocally "postgresql:///mediagoblin";
      };

      nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedProxySettings = true;
        virtualHosts = {
          # see https://git.sr.ht/~mediagoblin/mediagoblin/tree/bf61d38df21748aadb480c53fdd928647285e35f/item/nginx.conf.template
          "${cfg.domain}" = {
            forceSSL = true;
            extraConfig = ''
              # https://git.sr.ht/~mediagoblin/mediagoblin/tree/bf61d38df21748aadb480c53fdd928647285e35f/item/Dockerfile.nginx.in#L5
              client_max_body_size 100M;

              more_set_headers X-Content-Type-Options nosniff;
            '';
            locations = {
              "/".proxyPass = "http://127.0.0.1:${toString cfg.paste.port}";
              "/mgoblin_static/".alias = "${finalPackage}/${finalPackage.python.sitePackages}/mediagoblin/static/";
              "/mgoblin_media/".alias = "/var/lib/mediagoblin/user_dev/media/public/";
              "/theme_static/".alias = "/var/lib/mediagoblin/user_dev/theme_static/";
              "/plugin_static/".alias = "/var/lib/mediagoblin/user_dev/plugin_static/";
            };
          };
        };
      };

      postgresql = lib.mkIf cfg.createDatabaseLocally {
        enable = true;
        ensureDatabases = [ "mediagoblin" ];
        ensureUsers = [
          {
            name = "mediagoblin";
            ensureDBOwnership = true;
          }
        ];
      };

      rabbitmq.enable = true;
    };

    systemd.services =
      let
        serviceDefaults = {
          wantedBy = [ "multi-user.target" ];
          path =
            lib.optionals (cfg.settings.mediagoblin.plugins ? "mediagoblin.media_types.stl") [ pkgs.blender ]
            ++ lib.optionals (cfg.settings.mediagoblin.plugins ? "mediagoblin.media_types.pdf") (
              with pkgs;
              [
                poppler_utils
                unoconv
              ]
            );
          serviceConfig = {
            AmbientCapabilities = "";
            CapabilityBoundingSet = [ "" ];
            DevicePolicy = "closed";
            Group = "mediagoblin";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            ProcSubset = "pid";
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            ProtectSystem = "strict";
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
            ];
            RemoveIPC = true;
            StateDirectory = "mediagoblin";
            StateDirectoryMode = "0750";
            User = "mediagoblin";
            WorkingDirectory = "/var/lib/mediagoblin/";
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
              "@chown"
            ];
            UMask = "0027";
          };
        };

        generatedPasteConfig = iniFormat.generate "paste.ini" cfg.paste.settings;
        pasteConfig = pkgs.runCommand "paste-combined.ini" { nativeBuildInputs = [ pkgs.crudini ]; } ''
          cp ${cfg.package.src}/paste.ini $out
          chmod +w $out
          crudini --merge $out < ${generatedPasteConfig}
        '';
      in
      {
        mediagoblin-celeryd = lib.recursiveUpdate serviceDefaults {
          # we cannot change DEFAULT.data_dir inside mediagoblin.ini because of an annoying bug
          # https://todo.sr.ht/~mediagoblin/mediagoblin/57
          preStart = ''
            cp --remove-destination ${
              pkgs.writeText "mediagoblin.ini" (
                lib.generators.toINI { } (lib.filterAttrsRecursive (n: v: n != "plugins") cfg.settings)
                + "\n"
                + lib.generators.toINI { mkKeyValue = mkSubSectionKeyValue 2; } {
                  inherit (cfg.settings.mediagoblin) plugins;
                }
              )
            } /var/lib/mediagoblin/mediagoblin.ini
          '';
          serviceConfig = {
            Environment = [
              "CELERY_CONFIG_MODULE=mediagoblin.init.celery.from_celery"
              "GI_TYPELIB_PATH=${GI_TYPELIB_PATH}"
              "MEDIAGOBLIN_CONFIG=/var/lib/mediagoblin/mediagoblin.ini"
              "PASTE_CONFIG=${pasteConfig}"
            ];
            ExecStart = "${lib.getExe' finalPackage "celery"} worker --loglevel=INFO";
          };
          unitConfig.Description = "MediaGoblin Celery";
        };

        mediagoblin-paster = lib.recursiveUpdate serviceDefaults {
          after = [
            "mediagoblin-celeryd.service"
            "postgresql.service"
          ];
          requires = [
            "mediagoblin-celeryd.service"
            "postgresql.service"
          ];
          preStart = ''
            cp --remove-destination ${pasteConfig} /var/lib/mediagoblin/paste.ini
            ${lib.getExe' finalPackage "gmg"} dbupdate
          '';
          serviceConfig = {
            Environment = [
              "CELERY_ALWAYS_EAGER=false"
              "GI_TYPELIB_PATH=${GI_TYPELIB_PATH}"
            ];
            ExecStart = "${lib.getExe' finalPackage "paster"} serve /var/lib/mediagoblin/paste.ini";
          };
          unitConfig.Description = "Mediagoblin";
        };
      };

    systemd.tmpfiles.settings."mediagoblin"."/var/lib/mediagoblin/user_dev".d = {
      group = "mediagoblin";
      mode = "2750";
      user = "mediagoblin";
    };

    users = {
      groups.mediagoblin = { };
      users = {
        mediagoblin = {
          group = "mediagoblin";
          home = "/var/lib/mediagoblin";
          isSystemUser = true;
        };
        nginx.extraGroups = [ "mediagoblin" ];
      };
    };
  };
}
