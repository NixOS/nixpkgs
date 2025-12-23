{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.libretranslate;
  ltmanageKeysCli = pkgs.writeShellScriptBin "ltmanage-keys" ''
    set -a
    export HOME="/var/lib/libretranslate"
    sudo=exec
    if [[ "$USER" != ${cfg.user} ]]; then
      sudo='exec /run/wrappers/bin/sudo -u ${cfg.user} --preserve-env'
    fi
    $sudo ${cfg.package}/bin/ltmanage keys --api-keys-db-path ${cfg.dataDir}/db/api_keys.db "$@"
  '';

in
{
  options = {
    services.libretranslate = {
      enable = lib.mkEnableOption "LibreTranslate service";

      package = lib.mkPackageOption pkgs "libretranslate" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "libretranslate";
        description = "User account under which libretranslate runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "libretranslate";
        description = "Group account under which libretranslate runs.";
      };

      host = lib.mkOption {
        description = "The address the application should listen on.";
        type = lib.types.str;
        default = "127.0.0.1";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5000;
        description = "The the application should listen on.";
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/libretranslate";
        example = "/srv/data/libretranslate";
        description = "The data directory.";
      };

      threads = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.positive;
        default = null;
        example = 8;
        description = "Set number of threads.";
      };

      enableApiKeys = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Whether to enable the API keys database.";
      };

      disableWebUI = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Whether to disable the Web UI.";
      };

      updateModels = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Update language models at startup";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "libretranslate.example.com";
        description = ''
          The domain serving your LibreTranslate instance.
          Required for configure nginx as a reverse proxy.
        '';
      };

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Configure nginx as a reverse proxy for LibreTranslate.";
      };

      extraArgs = lib.mkOption {
        type =
          with lib.types;
          attrsOf (
            nullOr (oneOf [
              bool
              str
              int
              (listOf (oneOf [
                bool
                str
                int
              ]))
            ])
          );
        default = { };
        example = {
          debug = true;
          disable-files-translation = true;
          url-prefix = "translate";
        };
        description = "Extra arguments passed to the LibreTranslate.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.mkIf cfg.enableApiKeys [ ltmanageKeysCli ];

    systemd.tmpfiles.rules = lib.mkIf (cfg.dataDir != "/var/lib/libretranslate") [
      "d '${cfg.dataDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "z '${cfg.dataDir}' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.libretranslate = {
      description = "LibreTranslate service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        HOME = cfg.dataDir;
      };
      serviceConfig = lib.mkMerge [
        {
          Type = "simple";
          ExecStart = ''
            ${cfg.package}/bin/libretranslate ${
              lib.cli.toCommandLineShellGNU { } (
                cfg.extraArgs
                // {
                  inherit (cfg) host port threads;
                  api-keys = cfg.enableApiKeys;
                  disable-web-ui = cfg.disableWebUI;
                  update-models = cfg.updateModels;
                }
              )
            }
          '';
          WorkingDirectory = cfg.dataDir;
          User = cfg.user;
          Group = cfg.group;
          ProcSubset = "all";
          ProtectProc = "invisible";
          UMask = "0027";
          CapabilityBoundingSet = "";
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = false;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          PrivateMounts = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @setuid" ];
        }
        (lib.mkIf (cfg.dataDir == "/var/lib/libretranslate") {
          StateDirectory = "libretranslate";
          StateDirectoryMode = "0750";
        })
        (lib.mkIf (cfg.dataDir != "/var/lib/libretranslate") {
          ReadWritePaths = cfg.dataDir;
        })
      ];
    };

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      virtualHosts."${cfg.domain}" = {
        root = "/var/empty";

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
        };

        locations."= /favicon.ico" = {
          alias = "${cfg.package.static-compressed}/share/libretranslate/static/favicon.ico";
        };

        locations."^~ /static/" = {
          alias = "${cfg.package.static-compressed}/share/libretranslate/static/";
        };
      };
    };

    users.users = lib.optionalAttrs (cfg.user == "libretranslate") {
      libretranslate = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "libretranslate") {
      libretranslate = { };
    };
  };
}
