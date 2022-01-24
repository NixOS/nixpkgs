{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.criu;
in {

  options = {
    programs.criu = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Install <command>criu</command> along with necessary kernel options.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "CHECKPOINT_RESTORE")
    ];
    boot.kernel.features.criu = true;
    environment.systemPackages = [ pkgs.criu ];
  };

}
