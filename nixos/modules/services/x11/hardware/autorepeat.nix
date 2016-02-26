{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.xserver.autorepeat;
in {
  options = {
    services.xserver.autorepeat.enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable setting keyboard repeat rate";
    };

    services.xserver.autorepeat.delay = mkOption {
      description = "Delay before repeating keys";
      default = 660;
      type = types.int;
    };

    services.xserver.autorepeat.rate = mkOption {
      description = "Repeat rate of keys";
      default = 25;
      type = types.int;
    };
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.xserverArgs = [
      "-ardelay ${toString cfg.delay}"
      "-arinterval ${toString cfg.rate}"
    ];
  };
}
