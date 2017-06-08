{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.vim;
in {
  ###### interface
  options.programs.vim = {
    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = ''
        When enabled, installs the selected vim derivation and sets it to be
        the system-wide default editor using the EDITOR environment variable.
      '';
    };
    vimrc = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        The system-wide vim configuration.
      '';
      example = ''
        set nocompatible
      '';
    };
    gvimrc = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        The system-wide gvim configuration.
      '';
      example = ''
        set nocompatible
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.vim;
      defaultText = "pkgs.vim";
      description = ''
        Which vim derivation to use.
      '';
    };
  };

  ###### implementation
  config = mkMerge
    [
      (mkIf cfg.defaultEditor {
        environment.systemPackages = [ cfg.package ];
        environment.variables = {
          EDITOR = mkOverride 900 "${cfg.package}/bin/vim"; };
      })
      (mkIf (cfg.vimrc != "") {
        environment.etc."vim/vimrc".text = cfg.vimrc;
      })
      (mkIf (cfg.gvimrc != "") {
        environment.etc."vim/gvimrc".text = cfg.gvimrc;
      })
    ];
}
