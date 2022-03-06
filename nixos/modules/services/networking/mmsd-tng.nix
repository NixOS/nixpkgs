{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.services.mmsd-tng;

  dbusServiceFile = pkgs.writeTextFile rec {
    name = "org.ofono.mms.service";
    destination = "/share/dbus-1/services/${name}";
    text = ''
      [D-BUS Service]
      Name=org.ofono.mms
      Exec=${pkgs.mmsd-tng}/bin/mmsdtng
      SystemdService=mmsd-tng.service
    '';
  };
in
{
  options = {
    services.mmsd-tng = {
      enable = mkEnableOption "Multimedia Messaging Service Daemon - The Next Generation (mmsd-tng)";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.mmsd-tng = {
      description = "Multimedia Messaging Service Daemon - The Next Generation";
      serviceConfig = {
        Type = "dbus";
        BusName = "org.ofono.mms";
        ExecStart = "${pkgs.mmsd-tng}/bin/mmsdtng";
      };
    };

    services.dbus.packages = [ dbusServiceFile ];
  };
}
