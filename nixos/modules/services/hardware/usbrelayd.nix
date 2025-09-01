{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.usbrelayd;
in
{
  options.services.usbrelayd = with lib.types; {
    enable = lib.mkEnableOption "USB Relay MQTT daemon";

    broker = lib.mkOption {
      type = str;
      description = "Hostname or IP address of your MQTT Broker.";
      default = "127.0.0.1";
      example = [
        "mqtt"
        "192.168.1.1"
      ];
    };

    clientName = lib.mkOption {
      type = str;
      description = "Name, your client connects as.";
      default = "MyUSBRelay";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.etc."usbrelayd.conf".text = ''
      [MQTT]
      BROKER = ${cfg.broker}
      CLIENTNAME = ${cfg.clientName}
    '';

    services.udev.packages = [ pkgs.usbrelayd ];
    systemd.packages = [ pkgs.usbrelayd ];
    users.groups.usbrelay = { };
  };

  meta = {
    maintainers = with lib.maintainers; [ wentasah ];
  };
}
