{ config, pkgs, lib, ... }:

with lib;

let
  pkg = pkgs.oddjob;
  cfg = config.services.oddjobd;
in
{
  options.services.oddjobd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable the oddjob service which allows scheduling jobs over DBUS.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ pkgs.oddjob ];

    systemd.services.oddjobd = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "DBUS Odd-job Daemon";
      enable = true;
      documentation = ["man:oddjobd(8)" "man:oddjobd.conf(5)"];
      #serviceConfig = {
        #Type = "dbus";
        #BusName = "org.freedesktop.oddjob";
        #ExecStart = "${pkgs.oddjob}/bin/oddjobd";
      #};
    };
  };
}
