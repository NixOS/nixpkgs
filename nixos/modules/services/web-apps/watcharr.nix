{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.watcharr;
  settingsFormat = pkgs.formats.json { };
  stateDir = "/var/lib/watcharr";
in
{
  options.services.watcharr = {
    enable = lib.mkEnableOption "Watcharr";

    package = lib.mkPackageOption pkgs "watcharr" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the listen port (3080) in the firewall.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/watcharr.env";
      description = "Path to a systemd `EnvironmentFile` with secrets (e.g. `WATCHARR_JWT_SECRET`, `WATCHARR_TMDB_KEY`).";
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      example = {
        DEFAULT_COUNTRY = "JP";
        SIGNUP_ENABLED = false;
        JELLYFIN_HOST = "https://jellyfin.example.com";
      };
      description = ''
        Free-form configuration written to `watcharr.json` in the state dir on each start.
        Watcharr's admin UI also writes there; values set here are re-applied on every restart.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.watcharr = {
      description = "Watcharr, self-hosted watched list for movies, TV, anime, and games";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment.WATCHARR_DATA = stateDir;

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "watcharr";
        StateDirectoryMode = "0700";
        ExecStartPre = lib.mkIf (cfg.settings != { }) (
          "${pkgs.coreutils}/bin/install -m 0640 "
          + "${settingsFormat.generate "watcharr.json" cfg.settings} "
          + "${stateDir}/watcharr.json"
        );
        ExecStart = lib.getExe cfg.package;
        EnvironmentFile = cfg.environmentFile;
        Restart = "on-failure";

        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        DeviceAllow = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
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
          "@pkey"
          "@system-service"
          "~@privileged"
          "~@chown:EPERM"
          "~@keyring"
          "~@memlock"
          "~@resources"
          "~@setuid"
          "~@timer"
        ];
        UMask = "0077";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 3080 ];
    };
  };

  meta.maintainers = with lib.maintainers; [ miniharinn ];
}
