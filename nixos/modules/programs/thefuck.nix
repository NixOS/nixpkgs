{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.thefuck;
in
  {
    options = {
      programs.thefuck = {
        enable = mkEnableOption "thefuck";

        alias = mkOption {
          default = "fuck";
          type = types.string;

          description = ''
            `thefuck` needs an alias to be configured.
            The default value is `fuck`, but you can use anything else as well.
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ thefuck ];
      environment.shellInit = ''
        eval $(${pkgs.thefuck}/bin/thefuck --alias ${cfg.alias})
      '';
    };
  }
