{ config, pkgs, lib, ... }:

let
  cfg = config.programs.oddjobd;
in
{
  options = {
    programs.oddjobd = {
      enable = lib.mkEnableOption "oddjob, a D-Bus service which runs odd jobs on behalf of client applications";
      package = lib.mkPackageOption pkgs "oddjob" {};
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.oddjobd = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "dbus.service" ];
      description = "DBUS Odd-job Daemon";
      enable = true;
      documentation = [ "man:oddjobd(8)" "man:oddjobd.conf(5)" ];
      serviceConfig = {
        Type = "simple";
        PIDFile = "/run/oddjobd.pid";
        ExecStart = "${lib.getBin cfg.package}/bin/oddjobd -n -p /run/oddjobd.pid -t 300";
      };
    };

    services.dbus.packages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ SohamG ];
}
