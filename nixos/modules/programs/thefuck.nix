{ config, pkgs, lib, ... }:

with lib;

let
  prg = config.programs;
  cfg = prg.thefuck;

  initScript = ''
    eval $(${pkgs.thefuck}/bin/thefuck --alias ${cfg.alias})
  '';
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
      environment.shellInit = initScript;

      programs.zsh.shellInit = mkIf prg.zsh.enable initScript;
      programs.fish.shellInit = mkIf prg.fish.enable ''
        ${pkgs.thefuck}/bin/thefuck --alias | source
      '';
    };
  }
