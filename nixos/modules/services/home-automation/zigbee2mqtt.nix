{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.zigbee2mqtt;

  format = pkgs.formats.yaml { };
  configFile = format.generate "zigbee2mqtt.yaml" cfg.settings;

in
{
  meta.maintainers = with lib.maintainers; [
    sweber
    hexa
  ];

  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "zigbee2mqtt"
      "config"
    ] "The option services.zigbee2mqtt.config was renamed to services.zigbee2mqtt.settings.")
  ];

  options.services.zigbee2mqtt = {
    enable = lib.mkEnableOption "zigbee2mqtt service";

    package = lib.mkPackageOption pkgs "zigbee2mqtt" { };

    dataDir = lib.mkOption {
      description = "Zigbee2mqtt data directory";
      default = "/var/lib/zigbee2mqtt";
      type = lib.types.path;
    };

    settings = lib.mkOption {
      type = format.type;
      default = { };
      example = lib.literalExpression ''
        {
          homeassistant.enabled = config.services.home-assistant.enable;
          permit_join = true;
          serial = {
            port = "/dev/ttyACM1";
          };
        }
      '';
      description = ''
        Your {file}`configuration.yaml` as a Nix attribute set.
        Check the [documentation](https://www.zigbee2mqtt.io/information/configuration.html)
        for possible options.
      '';
    };
  };

  config = lib.mkIf (cfg.enable) {

    # preset config values
    services.zigbee2mqtt.settings = {
      homeassistant.enabled = lib.mkDefault config.services.home-assistant.enable;
      permit_join = lib.mkDefault false;
      mqtt = {
        base_topic = lib.mkDefault "zigbee2mqtt";
        server = lib.mkDefault "mqtt://localhost:1883";
      };
      serial.port = lib.mkDefault "/dev/ttyACM0";
      # reference device/group configuration, that is kept in a separate file
      # to prevent it being overwritten in the units ExecStartPre script
      devices = lib.mkDefault "devices.yaml";
      groups = lib.mkDefault "groups.yaml";
    };

    systemd.services.zigbee2mqtt = {
      description = "Zigbee2mqtt Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment.ZIGBEE2MQTT_DATA = cfg.dataDir;
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/zigbee2mqtt";
        User = "zigbee2mqtt";
        Group = "zigbee2mqtt";
        WorkingDirectory = cfg.dataDir;
        StateDirectory = "zigbee2mqtt";
        StateDirectoryMode = "0700";
        Restart = "on-failure";

        # Hardening
        CapabilityBoundingSet = "";
        DeviceAllow = lib.optionals (lib.hasPrefix "/" cfg.settings.serial.port) [
          cfg.settings.serial.port
        ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = false;
        NoNewPrivileges = true;
        PrivateDevices = false; # prevents access to /dev/serial, because it is set 0700 root:root
        PrivateUsers = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        ReadWritePaths = cfg.dataDir;
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SupplementaryGroups = [
          "dialout"
        ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service @pkey"
          "~@privileged @resources"
          "@chown"
        ];
        UMask = "0077";
      };
      preStart = ''
        cp --no-preserve=mode ${configFile} "${cfg.dataDir}/configuration.yaml"
      '';
    };

    users.users.zigbee2mqtt = {
      home = cfg.dataDir;
      createHome = true;
      group = "zigbee2mqtt";
      uid = config.ids.uids.zigbee2mqtt;
    };

    users.groups.zigbee2mqtt.gid = config.ids.gids.zigbee2mqtt;
  };
}
