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
  };

  config = lib.mkIf cfg.enable {
    security.wrappers."gsr-kms-server" = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+ep";
      source = "${package}/bin/gsr-kms-server";
    };
  };

  meta.maintainers = with lib.maintainers; [ timschumi ];
}
