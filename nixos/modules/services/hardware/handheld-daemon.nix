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
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "handheld-daemon"
      "adjustor"
      "package"
    ] "Adjustor is now part of handheld-daemon package, so it can't be overriden")
  ];
  options.services.handheld-daemon = {
    enable = lib.mkEnableOption "Handheld Daemon";
    package = lib.mkPackageOption pkgs "handheld-daemon" { };

    ui = {
      enable = lib.mkEnableOption "Handheld Daemon UI";
      package = lib.mkPackageOption pkgs "handheld-daemon-ui" { };
    };

    adjustor = {
      enable = lib.mkEnableOption "Handheld Daemon TDP control plugin";
      loadAcpiCallModule = lib.mkOption {
        type = lib.types.bool;
        description = ''
          Whether to load the acpi_call kernel module.
          Required for TDP control by adjustor on most devices.
        '';
      };
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
    services.handheld-daemon.adjustor.loadAcpiCallModule = lib.mkDefault cfg.adjustor.enable;
    environment.systemPackages = [
      cfg.package
    ]
    ++ lib.optional cfg.ui.enable cfg.ui.package;
    services.udev.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    boot.kernelModules = lib.mkIf cfg.adjustor.loadAcpiCallModule [ "acpi_call" ];
    boot.extraModulePackages = lib.mkIf cfg.adjustor.loadAcpiCallModule [
      config.boot.kernelPackages.acpi_call
    ];

    systemd.services.handheld-daemon = {
      description = "Handheld Daemon";

      wantedBy = [ "multi-user.target" ];

      restartIfChanged = true;

      environment = {
        HHD_ADJ_DISABLE = lib.mkIf (!cfg.adjustor.enable) "1";
      };

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

  meta.maintainers = [ lib.maintainers.toast ];
}
