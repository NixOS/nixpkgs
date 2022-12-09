{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fakeroute;
  routeConf = pkgs.writeText "route.conf" (concatStringsSep "\n" cfg.route);

in

{

  ###### interface

  options = {

    services.fakeroute = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the fakeroute service.
        '';
      };

      route = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [
          "216.102.187.130"
          "4.0.1.122"
          "198.116.142.34"
          "63.199.8.242"
        ];
        description = lib.mdDoc ''
         Fake route that will appear after the real
         one to any host running a traceroute.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.fakeroute = {
      description = "Fakeroute Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        User = "root";
        ExecStart = "${pkgs.fakeroute}/bin/fakeroute -f ${routeConf}";
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}
