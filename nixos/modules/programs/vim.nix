{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.vim;
in {
  options.programs.vim = {
    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = ''
        When enabled, installs vim and configures vim to be the default editor
        using the EDITOR environment variable.
        '';
    };

    vimrc = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Global vimrc configuration
      '';
    };
  };

  config = mkIf cfg.defaultEditor {
    environment.systemPackages = [ pkgs.vim_configurable ];
    environment.variables = { EDITOR = mkOverride 900 "vim"; };

    environment.etc."vimrc" = {
      enable = cfg.vimrc != "";
      text = cfg.vimrc;
    };
  };
}
