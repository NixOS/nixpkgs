# Module for the IPv6 Router Advertisement Daemon.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.radvd;

  confFile = pkgs.writeText "radvd.conf" cfg.config;

in

{

  ###### interface

  options.services.radvd = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
          Whether to enable the Router Advertisement Daemon
          ({command}`radvd`), which provides link-local
          advertisements of IPv6 router addresses and prefixes using
          the Neighbor Discovery Protocol (NDP).  This enables
          stateless address autoconfiguration in IPv6 clients on the
          network.
        '';
    };

    package = mkPackageOption pkgs "radvd" { };

    debugLevel = mkOption {
      type = types.int;
      default = 0;
      example = 5;
      description = ''
          The debugging level is an integer in the range from 1 to 5,
          from quiet to very verbose. A debugging level of 0 completely
          turns off debugging.
        '';
    };

    config = mkOption {
      type = types.lines;
      example =
        ''
          interface eth0 {
            AdvSendAdvert on;
            prefix 2001:db8:1234:5678::/64 { };
          };
        '';
      description = ''
          The contents of the radvd configuration file.
        '';
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.users.radvd =
      {
        isSystemUser = true;
        group = "radvd";
        description = "Router Advertisement Daemon User";
      };
    users.groups.radvd = {};

    systemd.services.radvd =
      { description = "IPv6 Router Advertisement Daemon";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig =
          { ExecStart = "@${cfg.package}/bin/radvd radvd -n -u radvd -d ${toString cfg.debugLevel} -C ${confFile}";
            Restart = "always";
          };
      };

  };

}
