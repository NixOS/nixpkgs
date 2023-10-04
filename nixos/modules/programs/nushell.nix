{ config, lib, pkgs, ... }:

with lib;

let

  cfge = config.environment;

  cfg = config.programs.nushell;

in

{

  options = {

    programs.nushell = {

      enable = mkOption {
        default = false;
        description = lib.mdDoc ''
          Whether to configure nushell as an interactive shell.
        '';
        type = types.bool;
      };

    };

  };

  config = mkIf cfg.enable {

    environment = mkMerge [
      { systemPackages = [ pkgs.nushell ]; }

      {
        shells = [
          "/run/current-system/sw/bin/nu"
          "${pkgs.nushell}${pkgs.nushell.passthru.shellPath}"
        ];
      }
    ];

  };

}
