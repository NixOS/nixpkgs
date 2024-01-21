{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.services.handheld-daemon;
in
{
  options.services.handheld-daemon = {
    enable = mkEnableOption "Enable Handheld Daemon";

    user = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        The user to run Handheld Daemon with.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.handheld-daemon ];
    services.udev.packages = [ pkgs.handheld-daemon ];
    systemd.packages = [ pkgs.handheld-daemon ];

    systemd.services.handheld-daemon = {
      description = "Handheld Daemon";

      wantedBy = [ "multi-user.target" ];

      restartIfChanged = true;

      serviceConfig = {
        ExecStart = "${ pkgs.handheld-daemon }/bin/hhd --user ${ cfg.user }";
        Nice = "-12";
        Restart = "on-failure";
        RestartSec = "10";
      };
    };
  };

  meta.maintainers = [ maintainers.appsforartists ];
}
