{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.picoshare;
in
{
  options.services.picoshare = {
    enable = lib.mkEnableOption "A minimalist, easy-to-host service for sharing images and other files";

    package = lib.mkPackageOption pkgs "picoshare" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 4001;
      description = "TCP port on which to listen for HTTP connections (defaults to 4001).";
    };

    behindProxy = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set to `true` for better logging when PicoShare is running behind a reverse proxy.";
    };

    secretFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to a file containing the passphrase for the admin user. Required if `PS_SHARED_SECRET` is not set.";
    };

    databasePath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/picoshare/store.db";
      description = "Path to picoshare's database.";
    };

    environment = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (lib.types.either lib.types.str lib.types.int);
      };
      default = { };
      description = "Environment variables to be set for the picoshare service. Can use systemd specifiers.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)`.

        The environment variables defined therein are passed to the oauth2-proxy instance protecting this client.
        You can use environment variables to pass secrets to the service without adding
        them to the world-redable nix store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.picoshare = {
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = {
        PORT = toString cfg.port;
        PS_BEHIND_PROXY = toString cfg.behindProxy;
        PS_SHARED_SECRET_FILE = "%d/picoshare-secret";
      }
      // (lib.mapAttrs (_: value: toString value) cfg.environment);
      unitConfig.Description = "picoshare service";
      serviceConfig = {
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        LoadCredential = "picoshare-secret:${cfg.secretFile}";
        ExecStart = "${lib.getExe cfg.package} -db ${cfg.databasePath}";
        RestartSec = 30;
        DynamicUser = true;
        RuntimeDirectory = "picoshare";
        StateDirectory = "picoshare";
        CacheDirectory = "picoshare";
        Restart = "on-failure";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        PrivateIPC = true;
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service @resources"
          "~@clock @debug @module @mount @reboot @swap @cpu-emulation @obsolete @timer @chown @setuid @privileged @keyring @ipc"
        ];
        SystemCallErrorNumber = "EPERM";
      };
    };
  };
}
