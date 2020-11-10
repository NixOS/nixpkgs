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
          type = types.str;

          description = ''
            `thefuck` needs an alias to be configured.
            The default value is `fuck`, but you can use anything else as well.
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ thefuck ];

      programs.bash.interactiveShellInit = initScript;
      programs.zsh.interactiveShellInit = mkIf prg.zsh.enable initScript;
      programs.fish.interactiveShellInit = mkIf prg.fish.enable ''
        ${pkgs.thefuck}/bin/thefuck --alias | source
      '';
    };
  }
