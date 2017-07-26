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
  };

  config = mkIf cfg.defaultEditor {
        environment.systemPackages = [ pkgs.vim ];
        environment.variables = { EDITOR = mkOverride 900 "vim"; };
  };
}
