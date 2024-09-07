{ config, lib, pkgs, ... }:
let
  cfg = config.services.cpupower-gui;
in {
  options = {
    services.cpupower-gui = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = ''
          Enables dbus/systemd service needed by cpupower-gui.
          These services are responsible for retrieving and modifying cpu power
          saving settings.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
