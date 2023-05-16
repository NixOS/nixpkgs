{ config, lib, pkgs, ... }:

<<<<<<< HEAD
let
  cfg = config.services.fakeroute;
  routeConf = pkgs.writeText "route.conf" (lib.concatStringsSep "\n" cfg.route);
=======
with lib;

let
  cfg = config.services.fakeroute;
  routeConf = pkgs.writeText "route.conf" (concatStringsSep "\n" cfg.route);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

in

{

  ###### interface

  options = {

    services.fakeroute = {

<<<<<<< HEAD
      enable = lib.mkEnableOption (lib.mdDoc "the fakeroute service");

      route = lib.mkOption {
        type = with lib.types; listOf str;
=======
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the fakeroute service.
        '';
      };

      route = mkOption {
        type = types.listOf types.str;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  config = lib.mkIf cfg.enable {
=======
  config = mkIf cfg.enable {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    systemd.services.fakeroute = {
      description = "Fakeroute Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
<<<<<<< HEAD
        User = "fakeroute";
        DynamicUser = true;
        AmbientCapabilities = [ "CAP_NET_RAW" ];
=======
        User = "root";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        ExecStart = "${pkgs.fakeroute}/bin/fakeroute -f ${routeConf}";
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}
