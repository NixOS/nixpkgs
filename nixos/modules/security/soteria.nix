{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.security.soteria;
in
{
  options.security.soteria = {
    enable = lib.mkEnableOption null // {
      description = ''
        Whether to enable Soteria, a Polkit authentication agent
        for any desktop environment.

        ::: {.note}
        You should only enable this if you are on a Desktop Environment that
        does not provide a graphical polkit authentication agent, or you are on
        a standalone window manager or Wayland compositor.
        :::
      '';
    };
    package = lib.mkPackageOption pkgs "soteria" { };
  };

  config = lib.mkIf cfg.enable {
    security.polkit.enable = true;
    environment.systemPackages = [ cfg.package ];

    systemd.user.services.polkit-soteria = {
      description = "Soteria, Polkit authentication agent for any desktop environment";

      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      script = lib.getExe cfg.package;
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ johnrtitor ];
}
