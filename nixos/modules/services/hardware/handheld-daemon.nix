{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.handheld-daemon;
  hhdPackage = cfg.package.override {
    withAdjustor = cfg.adjustor.enable;
    adjustor = cfg.adjustor.package;
  };
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
      loadAcpiCallModule = mkOption {
        type = types.bool;
        description = ''
          Whether to load the acpi_call kernel module.
          Required for TDP control by adjustor on most devices.
        '';
      };
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
    services.handheld-daemon.adjustor.loadAcpiCallModule = mkDefault cfg.adjustor.enable;
    environment.systemPackages = [
      hhdPackage
    ]
    ++ lib.optional cfg.ui.enable cfg.ui.package;
    services.udev.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    boot.kernelModules = mkIf cfg.adjustor.loadAcpiCallModule [ "acpi_call" ];
    boot.extraModulePackages = mkIf cfg.adjustor.loadAcpiCallModule [
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

  meta.maintainers = [ maintainers.toast ];
}
