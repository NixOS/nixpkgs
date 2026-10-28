{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.gpu-screen-recorder;
  package = cfg.package.override {
    inherit (config.security) wrapperDir;
  };

  notifPackage = cfg.ui.notifPackage;
  uiPackage = cfg.ui.package.override {
    gpu-screen-recorder = package;
    gpu-screen-recorder-notification = notifPackage;
    inherit (config.security) wrapperDir;
  };
in
{
  options = {
    programs.gpu-screen-recorder = {
      enable = lib.mkEnableOption "gpu-screen-recorder and setcap wrappers for promptless recording";

      package = lib.mkPackageOption pkgs "gpu-screen-recorder" { };

      ui = {
        enable = lib.mkEnableOption "the GPU Screen Recorder overlay UI";
        package = lib.mkPackageOption pkgs "gpu-screen-recorder-ui" { };
        notifPackage = lib.mkPackageOption pkgs "gpu-screen-recorder-notification" { };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.ui.enable {
      programs.gpu-screen-recorder.enable = true;

      environment.systemPackages = [
        uiPackage
        notifPackage
      ];

      security.wrappers."gsr-global-hotkeys" = {
        owner = "root";
        group = "root";
        capabilities = "cap_setuid+ep";
        source = lib.getExe' uiPackage "gsr-global-hotkeys";
      };
    })

    (lib.mkIf cfg.enable {
      environment.systemPackages = [ package ];

      security.wrappers."gsr-kms-server" = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+ep";
        source = lib.getExe' package "gsr-kms-server";
      };
    })
  ];

  meta.maintainers = with lib.maintainers; [
    timschumi
    AhmedAmr
    keenanweaver
  ];
}
