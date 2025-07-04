# urserver service
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.urserver;
in
{

  options.services.urserver.enable = lib.mkEnableOption "urserver";

  config = lib.mkIf cfg.enable {

    networking.firewall = {
      allowedTCPPorts = [
        9510
        9512
      ];
      allowedUDPPorts = [
        9511
        9512
      ];
    };

    systemd.user.services.urserver = {
      description = ''
        Server for Unified Remote: The one-and-only remote for your computer.
      '';
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = ''
          ${pkgs.urserver}/bin/urserver --daemon
        '';
        ExecStop = ''
          ${pkgs.procps}/bin/pkill urserver
        '';
        RestartSec = 3;
        Restart = "on-failure";
      };
    };
  };

}
