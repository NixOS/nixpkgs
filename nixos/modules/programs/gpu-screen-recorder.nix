{ config, lib, pkgs, ... }:

let
  cfg = config.programs.gpu-screen-recorder;
  package = cfg.package.override {
    inherit (config.security) wrapperDir;
  };
in {
  options = {
    programs.gpu-screen-recorder = {
      package = lib.mkPackageOption pkgs "gpu-screen-recorder" {};

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

    # The `cap_sys_nice` wrapper for `gpu-screen-recorder` is currently removed due to an upstream issue.
    # See the following link for more details:
    # https://git.dec05eba.com/gpu-screen-recorder/tree/extra/meson_post_install.sh?id=78e4620d9c87493509ff5bda2de11b7c36320287#n7

    environment.etc."modprobe.d/gsr-nvidia.conf".source = "${package}/lib/modprobe.d/gsr-nvidia.conf";
  };

  meta.maintainers = with lib.maintainers; [ timschumi ];
}
