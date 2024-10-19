{ config, lib, pkgs, ... }:

let cfg = config.programs.criu;
in {

  options = {
    programs.criu = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Install {command}`criu` along with necessary kernel options.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    boot.kernel.features.criu = true;
    environment.systemPackages = [ pkgs.criu ];
  };

}
