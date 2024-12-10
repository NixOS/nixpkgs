{ config, pkgs, lib, ... }:

let
  prg = config.programs;
  cfg = prg.thefuck;

  bashAndZshInitScript = ''
    eval $(${pkgs.thefuck}/bin/thefuck --alias ${cfg.alias})
  '';
  fishInitScript = ''
    ${pkgs.thefuck}/bin/thefuck --alias ${cfg.alias} | source
  '';
in
  {
    options = {
      programs.thefuck = {
        enable = lib.mkEnableOption "thefuck, an app which corrects your previous console command";

        alias = lib.mkOption {
          default = "fuck";
          type = lib.types.str;

          description = ''
            `thefuck` needs an alias to be configured.
            The default value is `fuck`, but you can use anything else as well.
          '';
        };
      };
    };

    config = lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ thefuck ];

      programs.bash.interactiveShellInit = bashAndZshInitScript;
      programs.zsh.interactiveShellInit = lib.mkIf prg.zsh.enable bashAndZshInitScript;
      programs.fish.interactiveShellInit = lib.mkIf prg.fish.enable fishInitScript;
    };
  }
