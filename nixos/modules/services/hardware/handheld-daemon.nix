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

    adjustor = {
      enable = mkEnableOption "Handheld Daemon TDP control plugin";
      package = mkPackageOption pkgs "adjustor" { };
    };

    user = mkOption {
      type = types.str;
      description = ''
        The user to run Handheld Daemon with.
      '';
    };
  };

  config = let
    hhdPackage = cfg.package.override {
      withAdjustor = cfg.adjustor.enable;
      adjustor = cfg.adjustor.package;
    };
  in mkIf cfg.enable {
    services.handheld-daemon.ui.enable = mkDefault true;
    environment.systemPackages = [
      hhdPackage
    ] ++ lib.optional cfg.ui.enable cfg.ui.package;
    services.udev.packages = [ hhdPackage ];
    systemd.packages = [ hhdPackage ];

    boot.extraModulePackages = mkIf cfg.adjustor.enable [
      config.boot.kernelPackages.acpi_call
    ];

    systemd.services.handheld-daemon = {
      description = "Handheld Daemon";

      wantedBy = [ "multi-user.target" ];

      restartIfChanged = true;

      path = mkIf cfg.ui.enable [
        cfg.ui.package
        pkgs.lsof
      ];

      serviceConfig = {
        ExecStart = "${lib.getExe hhdPackage} --user ${cfg.user}";
        Nice = "-12";
        Restart = "on-failure";
        RestartSec = "10";
      };
    };
  };

  meta.maintainers = [ maintainers.appsforartists ];
}
