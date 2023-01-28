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
        description = lib.mdDoc ''
          Whether to configure a setcap wrapper for traceroute.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.traceroute = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+p";
      source = "${pkgs.traceroute}/bin/traceroute";
    };
  };
}
