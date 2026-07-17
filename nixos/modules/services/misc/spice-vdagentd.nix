{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.spice-vdagentd;
in
{
  options = {
    services.spice-vdagentd = {
      enable = lib.mkEnableOption "Spice guest vdagent daemon";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.spice-vdagent ];

    systemd.services.spice-vdagentd = {
      description = "spice-vdagent daemon";
      wantedBy = [ "graphical.target" ];
      preStart = ''
        mkdir -p "/run/spice-vdagentd/"
      '';
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagentd";
      };
    };

    systemd.user.services.spice-vdagent = {
      description = "Spice guest session agent";
      documentation = [ "man:spice-vdagent(1)" ];
      unitConfig.ConditionPathExists = "/run/spice-vdagentd/spice-vdagent-sock";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent -x";
        StandardError = "null";
      };
    };
  };
}
