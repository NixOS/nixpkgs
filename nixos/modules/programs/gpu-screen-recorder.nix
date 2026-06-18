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

  uiPackage = cfg.ui.package.override {
    gpu-screen-recorder = package;
    inherit (config.security) wrapperDir;
  };
in
{
  options = {
    programs.gpu-screen-recorder = {
      package = lib.mkPackageOption pkgs "gpu-screen-recorder" { };

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to install gpu-screen-recorder and generate setcap
          wrappers for promptless recording.
        '';
      };

      ui = {
        enable = lib.mkEnableOption "the GPU Screen Recorder overlay UI";
        package = lib.mkPackageOption pkgs "gpu-screen-recorder-ui" { };
        notifPackage = lib.mkPackageOption pkgs "gpu-screen-recorder-notification" { };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ cfg.package ];

        security.wrappers."gsr-kms-server" = {
          owner = "root";
          group = "root";
          capabilities = "cap_sys_admin+ep";
          source = lib.getExe' package "gsr-kms-server";
        };
      }

      (lib.mkIf cfg.ui.enable {
        environment.systemPackages = [
          cfg.ui.package
          cfg.ui.notifPackage
        ];

        security.wrappers."gsr-global-hotkeys" = {
          owner = "root";
          group = "root";
          capabilities = "cap_setuid+ep";
          source = lib.getExe' uiPackage "gsr-global-hotkeys";
        };
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [
    timschumi
    AhmedAmr
  ];
}
