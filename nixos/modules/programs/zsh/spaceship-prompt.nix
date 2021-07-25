{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh.spaceship-prompt;
in {
  options = {
    programs.zsh.spaceship-prompt = {
      enable = mkEnableOption "spaceship-prompt";
      package = mkOption {
        default = pkgs.spaceship-prompt;
        defaultText = "pkgs.spaceship-prompt";
        description = ''
          Package to install `spaceship-prompt`
        '';
        type = types.package;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    programs.zsh.interactiveShellInit = ''
      source ${cfg.package}/lib/spaceship-prompt/spaceship.zsh
    '';
  };
}
