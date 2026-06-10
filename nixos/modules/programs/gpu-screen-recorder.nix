{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.gpu-screen-recorder;
  uiCfg = config.programs.gpu-screen-recorder-ui;
  package = cfg.package.override {
    inherit (config.security) wrapperDir;
  };
  uiPackage = uiCfg.package.override {
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
    };
    programs.gpu-screen-recorder-ui = {
      package = lib.mkPackageOption pkgs "gpu-screen-recorder-ui" { };
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to install gpu-screen-recorder-ui and generate setcap
          wrappers for global hotkeys. Enabling this also installs
          gpu-screen-recorder and its wrappers automatically.
        '';
      };
    };
  };
  config = lib.mkMerge [
    (lib.mkIf (cfg.enable || uiCfg.enable) {
      environment.systemPackages = [ cfg.package ];
      security.wrappers."gsr-kms-server" = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+ep";
        source = lib.getExe' package "gsr-kms-server";
      };
    })
    (lib.mkIf uiCfg.enable {
      environment.systemPackages = [ uiPackage ];
      security.wrappers."gsr-global-hotkeys" = {
        owner = "root";
        group = "root";
        capabilities = "cap_setuid+ep";
        source = lib.getExe' uiPackage "gsr-global-hotkeys";
      };
    })
  ];
  meta.maintainers = with lib.maintainers; [
    timschumi
    mowmdown
  ];
}
