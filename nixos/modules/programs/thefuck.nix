{ config, pkgs, lib, ... }:

with lib;

let
  prg = config.programs;
  cfg = prg.thefuck;

  initScript = pkgs.runCommand "fuck.sh"{}''
    ${pkgs.thefuck}/bin/thefuck --alias ${cfg.alias} > $out
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

      environment.shellFiles =  [ {
        bash_interactiveShellInit = initScript;
        fish_interactiveShellInit = initScript;
        zsh_interactiveShellInit = initScript;
      } ];
    };
  }
