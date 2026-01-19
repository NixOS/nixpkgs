{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.uptime-kuma;
in
{

  meta.maintainers = [ lib.maintainers.julienmalka ];

  options = {
    services.uptime-kuma = {
      enable = lib.mkEnableOption "Uptime Kuma, this assumes a reverse proxy to be set";

      package = lib.mkPackageOption pkgs "uptime-kuma" { };

      appriseSupport = lib.mkEnableOption "apprise support for notifications";

      settings = lib.mkOption {
        type = lib.types.submodule { freeformType = with lib.types; attrsOf str; };
        default = { };
        example = {
          PORT = "4000";
          NODE_EXTRA_CA_CERTS = lib.literalExpression "config.security.pki.caBundle";
          UPTIME_KUMA_DB_TYPE = "mariadb";
          UPTIME_KUMA_DB_HOSTNAME = "localhost";
          UPTIME_KUMA_DB_NAME = "uptime-kuma";
          UPTIME_KUMA_DB_USERNAME = "uptime-kuma";
          UPTIME_KUMA_DB_PASSWORD = "uptime-kuma";
        };
        description = ''
          Additional configuration for Uptime Kuma, see
          <https://github.com/louislam/uptime-kuma/wiki/Environment-Variables>
          for supported values.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    services.uptime-kuma.settings = {
      DATA_DIR = "/var/lib/uptime-kuma/";
      NODE_ENV = lib.mkDefault "production";
      HOST = lib.mkDefault "127.0.0.1";
      PORT = lib.mkDefault "3001";
      UPTIME_KUMA_DB_TYPE = lib.mkDefault "sqlite";
    };

    systemd.services.uptime-kuma = {
      description = "Uptime Kuma";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.settings;
      path = with pkgs; [ unixtools.ping ] ++ lib.optional cfg.appriseSupport apprise;
      serviceConfig = {
        Type = "simple";
        StateDirectory = "uptime-kuma";
        StateDirectoryMode = "750";
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/uptime-kuma-server";
        Restart = "on-failure";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = false; # enabling it breaks execution
        MountAPIVFS = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = "strict";
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
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = 27;
      };
    };
  };
}
