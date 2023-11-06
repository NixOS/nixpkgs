{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.spice-vdagent;
in
{
  options = {
    services.spice-vdagent = {
      enable = mkEnableOption (lib.mdDoc "Spice guest vdagent user daemon");
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.spice-vdagent ];

    systemd.user.services.spice-vdagent = {
      description = "spice-vdagent user daemon";
      wantedBy = [ "spice-vdagentd.target" ];
      after = [ "spice-vdagentd.service" ];
      serviceConfig = {
        ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent --foreground";
      };
    };
  };
}
