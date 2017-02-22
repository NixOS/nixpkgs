{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.programs.vim;
in {
  options.programs.vim = {
    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        When enabled, installs vim and configures vim to be the default editor
        using the EDITOR environment variable.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.vim;
      defaultText = "pkgs.vim";
      description = "VIM derivation to use";
    };
  };

  config = mkIf cfg.defaultEditor {
    environment.systemPackages = [ cfg.package ];
    environment.variables = { EDITOR = mkOverride 900 "vim"; };
  };
}
