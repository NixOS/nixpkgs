{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.mtr;
in {
  options = {
    programs.mtr = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to add mtr to the global environment and configure a
          setcap wrapper for it.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.mtr = {
      source = "${pkgs.mtr}/bin/mtr";
      capabilities = "cap_net_raw+p";
    };
  };
}
