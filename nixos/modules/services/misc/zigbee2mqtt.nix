{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.zigbee2mqtt;

  format = pkgs.formats.yaml { };
  configFile = format.generate "zigbee2mqtt.yaml" cfg.settings;

in
{
  meta.maintainers = with maintainers; [ sweber hexa ];

  imports = [
    # Remove warning before the 21.11 release
    (mkRenamedOptionModule [ "services" "zigbee2mqtt" "config" ] [ "services" "zigbee2mqtt" "settings" ])
  ];

  options.services.zigbee2mqtt = {
    enable = mkEnableOption "enable zigbee2mqtt service";

    package = mkOption {
      description = "Zigbee2mqtt package to use";
      default = pkgs.zigbee2mqtt;
      defaultText = literalExpression ''
        pkgs.zigbee2mqtt
      '';
      type = types.package;
    };

    dataDir = mkOption {
      description = "Zigbee2mqtt data directory";
      default = "/var/lib/zigbee2mqtt";
      type = types.path;
    };

    settings = mkOption {
      type = format.type;
      default = { };
      example = literalExpression ''
        {
          homeassistant = config.services.home-assistant.enable;
          permit_join = true;
          serial = {
            port = "/dev/ttyACM1";
          };
        }
      '';
      description = ''
        Your <filename>configuration.yaml</filename> as a Nix attribute set.
        Check the <link xlink:href="https://www.zigbee2mqtt.io/information/configuration.html">documentation</link>
        for possible options.
      '';
    };
  };

  config = mkIf (cfg.enable) {

    # preset config values
    services.zigbee2mqtt.settings = {
      homeassistant = mkDefault config.services.home-assistant.enable;
      permit_join = mkDefault false;
      mqtt = {
        base_topic = mkDefault "zigbee2mqtt";
        server = mkDefault "mqtt://localhost:1883";
      };
      serial.port = mkDefault "/dev/ttyACM0";
      # reference device configuration, that is kept in a separate file
      # to prevent it being overwritten in the units ExecStartPre script
      devices = mkDefault "devices.yaml";
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
        Restart = "on-failure";

        # Hardening
        CapabilityBoundingSet = "";
        DeviceAllow = [
          config.services.zigbee2mqtt.settings.serial.port
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
          "@system-service"
          "~@privileged"
          "~@resources"
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
