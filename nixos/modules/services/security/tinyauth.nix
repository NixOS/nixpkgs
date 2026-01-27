{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib)
    getExe
    maintainers
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalAttrs
    types
    ;

  cfg = config.services.tinyauth;

  format = pkgs.formats.keyValue { };
  settingsFile = format.generate "tinyauth-env-vars" cfg.settings;
in
{
  options.services.tinyauth = {
    enable = mkEnableOption "Tinyauth server";

    package = mkPackageOption pkgs "tinyauth" { };

    environmentFile = mkOption {
      type = types.path;
      description = ''
        Path to an environment file loaded for Tinyauth.

        This can be used to securely store tokens and secrets outside of the world-readable Nix store.

        Example contents of the file:
        ```
        USERS=user-hash
        PROVIDERS_GOOGLE_CLIENT_SECRET=your-client-secret
        ```
      '';
      default = "/dev/null";
      example = "/var/lib/secrets/tinyauth";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;

        options = {
          ADDRESS = mkOption {
            type = types.str;
            description = ''
              Address to bind the server to.
            '';
            default = "0.0.0.0";
          };

          APP_TITLE = mkOption {
            type = types.str;
            description = ''
              Title of the app.
            '';
            default = "Tinyauth";
          };

          APP_URL = mkOption {
            type = types.str;
            description = ''
              URL of the app.
            '';
            example = "https://auth.example.com";
          };

          DISABLE_ANALYTICS = mkOption {
            type = types.bool;
            description = ''
              Whether to disable anonymous version collection.
            '';
            default = false;
          };

          DISABLE_RESOURCES = mkOption {
            type = types.bool;
            description = ''
              Whether to disable the resources server.
            '';
            default = false;
          };

          LOGIN_MAX_RETRIES = mkOption {
            type = types.ints.unsigned;
            description = ''
              Maximum login attempts before timeout (0 to disable).
            '';
            default = 5;
          };

          LOGIN_TIMEOUT = mkOption {
            type = types.ints.unsigned;
            description = ''
              Login timeout in seconds after max retries reached (0 to disable).
            '';
            default = 300;
          };

          PORT = mkOption {
            type = types.port;
            description = ''
              The port to run the server on.
            '';
            default = 3000;
          };

          TRUSTED_PROXIES = mkOption {
            type = types.str;
            description = ''
              Comma-separated list of trusted proxies (IP addresses or CIDRs)
              for correct client IP detection.
            '';
            default = "";
          };
        };
      };

      default = { };

      description = ''
        Environment variables that will be passed to Tinyauth.
        See [configuration options](https://tinyauth.app/docs/reference/configuration)
        for supported values.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/tinyauth";
      description = ''
        The directory where Tinyauth will store its data.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "tinyauth";
      description = "User account under which Tinyauth runs.";
    };

    group = mkOption {
      type = types.str;
      default = "tinyauth";
      description = "Group account under which Tinyauth runs.";
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0750 '${cfg.user}' '${cfg.group}' - -"
    ];

    systemd.services.tinyauth = {
      description = "Tinyauth";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [
        cfg.package
        cfg.environmentFile
        settingsFile
      ];

      environment = {
        GIN_MODE = "release";
        DATABASE_PATH = "${cfg.dataDir}/tinyauth.db";
        RESOURCES_DIR = "${cfg.dataDir}/resources";
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        ExecStart = getExe cfg.package;
        Restart = "always";

        EnvironmentFile = [
          cfg.environmentFile
          settingsFile
        ];

        # Hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = "disconnected";
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths = [ cfg.dataDir ];
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };

    users.users = optionalAttrs (cfg.user == "tinyauth") {
      tinyauth = {
        isSystemUser = true;
        group = cfg.group;
        description = "Tinyauth user";
        home = cfg.dataDir;
      };
    };

    users.groups = optionalAttrs (cfg.group == "tinyauth") {
      tinyauth = { };
    };
  };

  meta.maintainers = with maintainers; [ shaunren ];
}
