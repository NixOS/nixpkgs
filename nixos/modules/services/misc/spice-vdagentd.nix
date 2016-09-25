{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.spice-vdagentd;
in
{
  options = {
    services.spice-vdagentd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Whether to enable Spice guest vdagent daemon.";
      };
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
        ExecStart = "/bin/sh -c '${pkgs.spice-vdagent}/bin/spice-vdagentd'";
      };
    };
  };
}
