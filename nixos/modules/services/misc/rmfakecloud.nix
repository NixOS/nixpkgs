{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.rmfakecloud;
  serviceDataDir = "/var/lib/rmfakecloud";

in {
  options = {
    services.rmfakecloud = {
      enable = mkEnableOption (lib.mdDoc "rmfakecloud remarkable self-hosted cloud");

      package = mkOption {
        type = types.package;
        default = pkgs.rmfakecloud;
        defaultText = literalExpression "pkgs.rmfakecloud";
        description = lib.mdDoc ''
          rmfakecloud package to use.

          The default does not include the web user interface.
        '';
      };

      storageUrl = mkOption {
        type = types.str;
        example = "https://local.appspot.com";
        description = lib.mdDoc ''
          URL used by the tablet to access the rmfakecloud service.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 3000;
        description = lib.mdDoc ''
          Listening port number.
        '';
      };

      logLevel = mkOption {
        type = types.enum [ "info" "debug" "warn" "error" ];
        default = "info";
        description = lib.mdDoc ''
          Logging level.
        '';
      };

      extraSettings = mkOption {
        type = with types; attrsOf str;
        default = { };
        example = { DATADIR = "/custom/path/for/rmfakecloud/data"; };
        description = lib.mdDoc ''
          Extra settings in the form of a set of key-value pairs.
          For tokens and secrets, use `environmentFile` instead.

          Available settings are listed on
          https://ddvk.github.io/rmfakecloud/install/configuration/.
        '';
      };

      environmentFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/etc/secrets/rmfakecloud.env";
        description = lib.mdDoc ''
          Path to an environment file loaded for the rmfakecloud service.

          This can be used to securely store tokens and secrets outside of the
          world-readable Nix store. Since this file is read by systemd, it may
          have permission 0400 and be owned by root.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.rmfakecloud = {
      description = "rmfakecloud remarkable self-hosted cloud";

      environment = {
        STORAGE_URL = cfg.storageUrl;
        PORT = toString cfg.port;
        LOGLEVEL = cfg.logLevel;
      } // cfg.extraSettings;

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

        EnvironmentFile =
          mkIf (cfg.environmentFile != null) cfg.environmentFile;

        AmbientCapabilities =
          mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];

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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        WorkingDirectory = serviceDataDir;
        StateDirectory = baseNameOf serviceDataDir;
        UMask = "0027";
      };
    };
  };

  meta.maintainers = with maintainers; [ pacien ];
}
