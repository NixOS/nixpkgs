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
    mapAttrs'
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    nameValuePair
    optionalAttrs
    types
    ;

  cfg = config.services.tinyauth;

  format = pkgs.formats.keyValue { };
  settingsFile = format.generate "tinyauth-env-vars" (
    mapAttrs' (name: value: nameValuePair "TINYAUTH_${name}" value) cfg.settings
  );
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
        TINYAUTH_AUTH_USERS=user-hash
        TINYAUTH_OAUTH_PROVIDERS_GOOGLE_CLIENTSECRET=client-secret
        ```
      '';
      default = "/dev/null";
      example = "/var/lib/secrets/tinyauth";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;

        options = {
          SERVER_ADDRESS = mkOption {
            type = types.str;
            description = ''
              Address to bind the server to.
            '';
            default = "0.0.0.0";
          };

          SERVER_PORT = mkOption {
            type = types.port;
            description = ''
              The port to run the server on.
            '';
            default = 3000;
          };

          APPURL = mkOption {
            type = types.str;
            description = ''
              URL of the app.
            '';
            example = "https://auth.example.com";
          };

          ANALYTICS_ENABLED = mkOption {
            type = types.bool;
            description = ''
              Whether to enable anonymous version collection.
            '';
            default = false;
          };

          RESOURCES_ENABLED = mkOption {
            type = types.bool;
            description = ''
              Whether to enable the resources server.
            '';
            default = true;
          };

          AUTH_LOGINMAXRETRIES = mkOption {
            type = types.ints.unsigned;
            description = ''
              Maximum login attempts before timeout (0 to disable).
            '';
            default = 3;
          };

          AUTH_LOGINTIMEOUT = mkOption {
            type = types.ints.unsigned;
            description = ''
              Login timeout in seconds after max retries reached (0 to disable).
            '';
            default = 300;
          };

          AUTH_TRUSTEDPROXIES = mkOption {
            type = types.str;
            description = ''
              Comma-separated list of trusted proxy addresses.
            '';
            default = "";
          };
        };
      };

      default = { };

      description = ''
        Environment variables that will be passed to Tinyauth.
        The "TINYAUTH_" prefix will be prepended to the setting names.
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
    systemd.tmpfiles.settings.tinyauth = {
      "${cfg.dataDir}".d = {
        mode = "0750";
        user = cfg.user;
        group = cfg.group;
      };
    };

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
        TINYAUTH_DATABASE_PATH = "${cfg.dataDir}/tinyauth.db";
        TINYAUTH_RESOURCES_PATH = "${cfg.dataDir}/resources";
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
