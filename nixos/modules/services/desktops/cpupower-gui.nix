{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cpupower-gui;
in
{
  options = {
    services.cpupower-gui = {
      enable = lib.mkEnableOption "cpupower-gui, along with the D-Bus and systemd services it uses to retrieve and modify CPU power saving settings";
      package = lib.mkPackageOption pkgs "cpupower-gui" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    systemd.user = {
      services.cpupower-gui-user = {
        description = "Apply cpupower-gui config at user login";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getExe cfg.package} config --apply";
        };
      };
    };
    systemd.services = {
      cpupower-gui = {
        description = "Apply cpupower-gui config at boot";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getExe cfg.package} config --apply";
        };
      };
      cpupower-gui-helper = {
        description = "cpupower-gui system helper";
        aliases = [ "dbus-org.rnd2.cpupower_gui.helper.service" ];
        serviceConfig = {
          Type = "dbus";
          BusName = "org.rnd2.cpupower_gui.helper";
          ExecStart = "${cfg.package}/lib/cpupower-gui/cpupower-gui-helper";
        };
      };
    };
  };
}
