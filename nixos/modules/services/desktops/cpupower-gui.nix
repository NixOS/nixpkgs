{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cpupower-gui;
in {
  options = {
    services.cpupower-gui = {
      enable = mkEnableOption "cpupower-gui";
      description = ''
        Enables dbus/systemd service needed used by cpupower-gui
        to retrieve and modify cpu power saving settings.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.cpupower-gui ];
    services.dbus.packages = [ pkgs.cpupower-gui ];
    systemd.user = {
      services.cpupower-gui-user = {
        description = "Apply cpupower-gui config at user login";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.cpupower-gui}/bin/cpupower-gui config";
        };
      };
    };
    systemd.services = {
      cpupower-gui = {
        description = "Apply cpupower-gui config at boot";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.cpupower-gui}/bin/cpupower-gui config";
        };
      };
      cpupower-gui-helper = {
        description = "cpupower-gui system helper";
        aliases = [ "dbus-org.rnd2.cpupower_gui.helper.service" ];
        serviceConfig = {
          Type = "dbus";
          BusName = "org.rnd2.cpupower_gui.helper";
          ExecStart = "${pkgs.cpupower-gui}/lib/cpupower-gui/cpupower-gui-helper";
        };
      };
    };
  };
}
