{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.handheld-daemon;
in
{
  options.services.handheld-daemon = {
    enable = mkEnableOption "Handheld Daemon";
    package = mkPackageOption pkgs "handheld-daemon" { };

    ui = {
      enable = mkEnableOption "Handheld Daemon UI";
      package = mkPackageOption pkgs "handheld-daemon-ui" { };
    };

    user = mkOption {
      type = types.str;
      description = ''
        The user to run Handheld Daemon with.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.handheld-daemon.ui.enable = mkDefault true;
    environment.systemPackages = [
      cfg.package
    ] ++ lib.optional cfg.ui.enable cfg.ui.package;
    services.udev.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    systemd.services.handheld-daemon = {
      description = "Handheld Daemon";

      wantedBy = [ "multi-user.target" ];

      restartIfChanged = true;

      path = mkIf cfg.ui.enable [
        cfg.ui.package
        pkgs.lsof
      ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --user ${cfg.user}";
        Nice = "-12";
        Restart = "on-failure";
        RestartSec = "10";
      };
    };
  };

  meta.maintainers = [ maintainers.appsforartists ];
}
