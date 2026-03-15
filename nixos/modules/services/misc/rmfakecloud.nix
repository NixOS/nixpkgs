{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.rmfakecloud;
  serviceDataDir = "/var/lib/rmfakecloud";
  isCustomDataDir = cfg.dataDir != serviceDataDir;
in
{
  options = {
    services.rmfakecloud = {
      enable = lib.mkEnableOption "rmfakecloud remarkable self-hosted cloud";

      package = lib.mkPackageOption pkgs "rmfakecloud" { };

      storageUrl = lib.mkOption {
        type = lib.types.str;
        example = "https://local.appspot.com";
        description = ''
          URL used by the tablet to access the rmfakecloud service.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = ''
          Listening port number.
        '';
      };

      logLevel = lib.mkOption {
        type = lib.types.enum [
          "info"
          "debug"
          "warn"
          "error"
        ];
        default = "info";
        description = ''
          Logging level.
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "${serviceDataDir}";
        description = ''
          The directory where rmfakecloud stores its data files.

          Note: A bind mount will be used to mount the directory at the expected location
          if a different value than `${serviceDataDir}` is used.
        '';
      };

      extraSettings = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = { };
        example = {
          RM_TRUST_PROXY = "true"; # if running behind a reverse proxy
          MQTT_PORT = "8883";
        };
        description = ''
          Extra settings in the form of a set of key-value pairs.
          For tokens and secrets, use `environmentFile` instead.

          Available settings are listed on
          https://ddvk.github.io/rmfakecloud/install/configuration/.
        '';
      };

      environmentFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        example = "/etc/secrets/rmfakecloud.env";
        description = ''
          Path to an environment file loaded for the rmfakecloud service.

          This can be used to securely store tokens and secrets outside of the
          world-readable Nix store. Since this file is read by systemd, it may
          have permission 0400 and be owned by root.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      services.rmfakecloud = {
        description = "rmfakecloud remarkable self-hosted cloud";

        environment = {
          STORAGE_URL = cfg.storageUrl;
          PORT = toString cfg.port;
          LOGLEVEL = cfg.logLevel;
          DATADIR = serviceDataDir;
        }
        // cfg.extraSettings;

        preStart = ''
          # Generate the secret key used to sign client session tokens.
          # Replacing it invalidates the previously established sessions.
          if [ -z "$JWT_SECRET_KEY" ] && [ ! -f jwt_secret_key ]; then
            (umask 077; touch jwt_secret_key)
            cat /dev/urandom | tr -cd '[:alnum:]' | head -c 48 >> jwt_secret_key
          fi
        '';

        script = ''
          if [ -z "$JWT_SECRET_KEY" ]; then
            export JWT_SECRET_KEY="$(cat jwt_secret_key)"
          fi

          ${cfg.package}/bin/rmfakecloud
        '';

        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];

        serviceConfig = {
          Type = "simple";
          Restart = "always";

          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

          AmbientCapabilities = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];

          DynamicUser = true;
          PrivateDevices = true;
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          CapabilityBoundingSet = [ "" ];
          DevicePolicy = "closed";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          ProtectClock = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          WorkingDirectory = serviceDataDir;
          StateDirectory = baseNameOf serviceDataDir;
          UMask = "0027";
        };
      };

      tmpfiles.settings."10-rmfakecloud".${cfg.dataDir}.d = lib.mkIf isCustomDataDir {
        user = "root";
        group = "root";
        mode = "0700";
      };

      mounts = lib.optional isCustomDataDir {
        what = cfg.dataDir;
        where = "/var/lib/private/rmfakecloud";
        options = "bind";
        wantedBy = [ "local-fs.target" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ euxane ];
}
