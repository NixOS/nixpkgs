{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.fakeroute;
  routeConf = pkgs.writeText "route.conf" (lib.concatStringsSep "\n" cfg.route);

in

{

  ###### interface

  options = {

    services.fakeroute = {

      enable = lib.mkEnableOption "the fakeroute service";

      route = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        example = [
          "216.102.187.130"
          "4.0.1.122"
          "198.116.142.34"
          "63.199.8.242"
        ];
        description = ''
          Fake route that will appear after the real
          one to any host running a traceroute.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    systemd.services.fakeroute = {
      description = "Fakeroute Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        User = "fakeroute";
        DynamicUser = true;
        AmbientCapabilities = [ "CAP_NET_RAW" ];
        ExecStart = "${pkgs.fakeroute}/bin/fakeroute -f ${routeConf}";
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}
