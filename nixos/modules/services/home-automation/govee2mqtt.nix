{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.govee2mqtt;
in
{
  meta.maintainers = with lib.maintainers; [ SuperSandro2000 ];

  options.services.govee2mqtt = {
    enable = lib.mkEnableOption "Govee2MQTT";

    package = lib.mkPackageOption pkgs "govee2mqtt" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "govee2mqtt";
      description = "User under which Govee2MQTT should run.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "govee2mqtt";
      description = "Group under which Govee2MQTT should run.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.path;
      example = "/var/lib/govee2mqtt/govee2mqtt.env";
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)`.

        See upstream documentation <https://github.com/wez/govee2mqtt/blob/main/docs/CONFIG.md>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups.${cfg.group} = { };
      users.${cfg.user} = {
        description = "Govee2MQTT service user";
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    systemd.services.govee2mqtt = {
      description = "Govee2MQTT Service";
      wantedBy = [ "multi-user.target" ];
      after = [
        "networking.target"
        "network-online.target"
      ];
      requires = [ "network-online.target" ];
      serviceConfig = {
        CacheDirectory = "govee2mqtt";
        Environment = [
          "GOVEE_CACHE_DIR=/var/cache/govee2mqtt"
        ];
        EnvironmentFile = cfg.environmentFile;
        ExecStart =
          "${lib.getExe cfg.package} serve --govee-iot-key=/var/lib/govee2mqtt/iot.key --govee-iot-cert=/var/lib/govee2mqtt/iot.cert"
          + " --amazon-root-ca=${pkgs.cacert.unbundled}/etc/ssl/certs/Amazon_Root_CA_1:66c9fcf99bf8c0a39e2f0788a43e696365bca.crt";
        Group = cfg.group;
        Restart = "on-failure";
        StateDirectory = "govee2mqtt";
        User = cfg.user;

        # Hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
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
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
      };
    };
  };
}
