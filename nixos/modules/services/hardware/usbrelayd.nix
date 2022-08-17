{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.usbrelayd;
in
{
  options.services.usbrelayd = with types; {
    enable = mkEnableOption "USB Relay MQTT daemon";

    broker = mkOption {
      type = str;
      description = lib.mdDoc "Hostname or IP address of your MQTT Broker.";
      default = "127.0.0.1";
      example = [
        "mqtt"
        "192.168.1.1"
      ];
    };

    clientName = mkOption {
      type = str;
      description = lib.mdDoc "Name, your client connects as.";
      default = "MyUSBRelay";
    };
  };

  config = mkIf cfg.enable {

    environment.etc."usbrelayd.conf".text = ''
      [MQTT]
      BROKER = ${cfg.broker}
      CLIENTNAME = ${cfg.clientName}
    '';

    services.udev.packages = [ pkgs.usbrelayd ];
    systemd.packages = [ pkgs.usbrelayd ];
    users.users.usbrelay = {
      isSystemUser = true;
      group = "usbrelay";
    };
    users.groups.usbrelay = { };
  };

  meta = {
    maintainers = with lib.maintainers; [ wentasah ];
  };
}
