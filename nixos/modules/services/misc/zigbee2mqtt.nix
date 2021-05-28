{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.zigbee2mqtt;

  configJSON = pkgs.writeText "configuration.json"
    (builtins.toJSON (recursiveUpdate defaultConfig cfg.config));
  configFile = pkgs.runCommand "configuration.yaml" { preferLocalBuild = true; } ''
    ${pkgs.remarshal}/bin/json2yaml -i ${configJSON} -o $out
  '';

  # the default config contains all required settings,
  # so the service starts up without crashing.
  defaultConfig = {
    homeassistant = false;
    permit_join = false;
    mqtt = {
      base_topic = "zigbee2mqtt";
      server = "mqtt://localhost:1883";
    };
    serial.port = "/dev/ttyACM0";
    # put device configuration into separate file because configuration.yaml
    # is copied from the store on startup
    devices = "devices.yaml";
  };
in
{
  meta.maintainers = with maintainers; [ sweber ];

  options.services.zigbee2mqtt = {
    enable = mkEnableOption "enable zigbee2mqtt service";

    package = mkOption {
      description = "Zigbee2mqtt package to use";
      default = pkgs.zigbee2mqtt.override {
        dataDir = cfg.dataDir;
      };
      defaultText = "pkgs.zigbee2mqtt";
      type = types.package;
    };

    dataDir = mkOption {
      description = "Zigbee2mqtt data directory";
      default = "/var/lib/zigbee2mqtt";
      type = types.path;
    };

    config = mkOption {
      default = {};
      type = with types; nullOr attrs;
      example = literalExample ''
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
      '';
    };
  };

  config = mkIf (cfg.enable) {
    systemd.services.zigbee2mqtt = {
      description = "Zigbee2mqtt Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/zigbee2mqtt";
        User = "zigbee2mqtt";
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
        ProtectSystem = "strict";
        ReadWritePaths = cfg.dataDir;
        PrivateTmp = true;
        RemoveIPC = true;
      };
      preStart = ''
        cp --no-preserve=mode ${configFile} "${cfg.dataDir}/configuration.yaml"
      '';
    };

    users.users.zigbee2mqtt = {
      home = cfg.dataDir;
      createHome = true;
      group = "zigbee2mqtt";
      extraGroups = [ "dialout" ];
      uid = config.ids.uids.zigbee2mqtt;
    };

    users.groups.zigbee2mqtt.gid = config.ids.gids.zigbee2mqtt;
  };
}
