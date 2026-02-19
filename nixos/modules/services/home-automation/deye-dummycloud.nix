{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.deye-dummycloud;
in
{
  options.services.deye-dummycloud = {
    enable = lib.mkEnableOption "the deye-dummycloud service";

    mqttBrokerUrl = lib.mkOption {
      type = lib.types.str;
      default = "mqtt://localhost";
      description = "MQTT broker URL";
    };
    mqttUsername = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "MQTT username";
    };
    mqttPassword = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "MQTT password";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.deye-dummycloud = {
      description = "Dummycloud server for DEYE microinverters and bridge to mqtt";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        WorkingDirectory = "${pkgs.deye-dummycloud}/lib/node_modules/deye-dummycloud";
        ExecStart = "${pkgs.nodejs}/bin/node app.js";
        Restart = "always";
        User = "deye-dummycloud";
        DynamicUser = true;
        ProtectSystem = "full";
        ProtectHome = true;
        Environment = [
          "MQTT_BROKER_URL=${cfg.mqttBrokerUrl}"
          "MQTT_USERNAME=${cfg.mqttUsername}"
          "MQTT_PASSWORD=${cfg.mqttPassword}"
        ];
      };
    };

    environment.systemPackages = [ pkgs.deye-dummycloud ];
  };
}
