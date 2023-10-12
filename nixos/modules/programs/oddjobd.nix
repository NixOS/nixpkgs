{ config, pkgs, lib, ... }:

let
  cfg = config.programs.oddjobd;
in
{
  options.programs.oddjobd = {
    enable = lib.mkEnableOption "oddjob";
    package = lib.mkPackageOption pkgs "oddjob" {};
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      { assertion = false;
        message = "The oddjob service was found to be broken without NixOS test or maintainer. Please take ownership of this service.";
      }
    ];
    systemd.packages = [ cfg.package ];

    systemd.services.oddjobd = {
      wantedBy = [ "multi-user.target"];
      after = [ "network.target"];
      description = "DBUS Odd-job Daemon";
      enable = true;
      documentation = [ "man:oddjobd(8)" "man:oddjobd.conf(5)" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.oddjob";
        ExecStart = "${lib.getBin cfg.package}/bin/oddjobd";
      };
    };
  };
}
