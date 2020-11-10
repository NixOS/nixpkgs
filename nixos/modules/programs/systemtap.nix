{ config, lib, ... }:

with lib;

let cfg = config.programs.systemtap;
in {

  options = {
    programs.systemtap = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Install <command>systemtap</command> along with necessary kernel options.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "DEBUG")
    ];
    boot.kernel.features.debug = true;
    environment.systemPackages = [
      config.boot.kernelPackages.systemtap
    ];
  };

}
