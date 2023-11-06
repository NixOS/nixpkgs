{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.spice-vdagentd;
in
{
  options = {
    services.spice-vdagentd = {
      enable = mkEnableOption (lib.mdDoc "Spice guest vdagent system daemon");
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.spice-vdagent ];

    systemd.services.spice-vdagentd = {
      description = "spice-vdagent system daemon";
      wantedBy = [ "graphical.target" ];
      preStart = ''
        mkdir -p "/run/spice-vdagentd/"
      '';
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagentd";
      };
    };
  };
}
