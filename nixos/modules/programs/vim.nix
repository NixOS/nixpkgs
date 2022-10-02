{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.vim;
in {
  options.programs.vim = {
    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        When enabled, installs vim and configures vim to be the default editor
        using the EDITOR environment variable.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.vim;
      defaultText = literalExpression "pkgs.vim";
      example = literalExpression "pkgs.vimHugeX";
      description = lib.mdDoc ''
        vim package to use.
      '';
    };
  };

  config = mkIf cfg.defaultEditor {
    environment.systemPackages = [ cfg.package ];
    environment.variables = { EDITOR = mkOverride 900 "vim"; };
  };
}
