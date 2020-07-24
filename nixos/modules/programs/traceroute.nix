{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.traceroute;
in {
  options = {
    programs.traceroute = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to configure a setcap wrapper for traceroute.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.traceroute = {
      source = "${pkgs.traceroute}/bin/traceroute";
      capabilities = "cap_net_raw+p";
    };
  };
}
