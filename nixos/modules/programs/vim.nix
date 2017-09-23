{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.vim;
in {
  options.programs.vim = {
    enable = mkOption {
      type = types.bool;
      default = cfg.defaultEditor;
      description = "When enabled, installs vim globally";
    };

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Configures vim to be the default editor using the EDITOR environment
        variable and installs vim globally by default.
      '';
    };

    vimrc = mkOption {
      type = types.lines;
      default = "";
      description = "Global vimrc configuration";
    };
  };

  config = mkMerge [{
    environment.systemPackages = mkIf cfg.enable [ pkgs.vim_configurable ];

    environment.etc."vimrc" = {
      enable = cfg.vimrc != "";
      text = cfg.vimrc;
    };
  } (mkIf cfg.defaultEditor {
    environment.variables = { EDITOR = mkOverride 900 "vim"; };
  })];
}
