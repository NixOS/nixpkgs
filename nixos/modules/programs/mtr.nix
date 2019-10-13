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

      package = mkOption {
        type = types.package;
        default = pkgs.mtr;
        description = ''
          The package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ cfg.package ];

    security.wrappers.mtr-packet = {
      source = "${cfg.package}/bin/mtr-packet";
      capabilities = "cap_net_raw+p";
    };
  };
}
