{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.spice-vdagentd;
in
{
  options = {
    services.spice-vdagentd = {
      enable = mkEnableOption "Spice guest vdagent daemon";
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.spice-vdagent ];

    systemd.services.spice-vdagentd = {
      description = "spice-vdagent daemon";
      wantedBy = [ "graphical.target" ];
      preStart = ''
        mkdir -p "/var/run/spice-vdagentd/"
      '';
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagentd";
      };
    };
  };
}
