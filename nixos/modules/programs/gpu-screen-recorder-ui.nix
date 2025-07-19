{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.gpu-screen-recorder-ui;
  package = cfg.package.override {
    inherit (config.security) wrapperDir;
  };
in
{
  options = {
    programs.gpu-screen-recorder-ui = {
      package = lib.mkPackageOption pkgs "gpu-screen-recorder-ui" { };

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to install gpu-screen-recorder-ui and generate setcap
          wrappers for global hotkeys.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gpu-screen-recorder.enable = lib.mkDefault true;

    environment.systemPackages = [ package ];

    systemd.packages = [ package ];

    security.wrappers."gsr-global-hotkeys" = {
      owner = "root";
      group = "root";
      capabilities = "cap_setuid+ep";
      source = lib.getExe' package "gsr-global-hotkeys";
    };
  };

  meta.maintainers = with lib.maintainers; [ js6pak ];
}
