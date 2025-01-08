{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.handheld-daemon;
in
{
  options.services.handheld-daemon = {
    enable = lib.mkEnableOption "Handheld Daemon";
    package = lib.mkPackageOption pkgs "handheld-daemon" { };

    ui = {
      enable = lib.mkEnableOption "Handheld Daemon UI";
      package = lib.mkPackageOption pkgs "handheld-daemon-ui" { };
    };

    user = lib.mkOption {
      type = lib.types.str;
      description = ''
        The user to run Handheld Daemon with.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.handheld-daemon.ui.enable = lib.mkDefault true;
    environment.systemPackages = [
      cfg.package
    ] ++ lib.optional cfg.ui.enable cfg.ui.package;
    services.udev.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    systemd.services.handheld-daemon = {
      description = "Handheld Daemon";

      wantedBy = [ "multi-user.target" ];

      restartIfChanged = true;

      path = lib.mkIf cfg.ui.enable [
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

  meta.maintainers = [ lib.maintainers.appsforartists ];
}
