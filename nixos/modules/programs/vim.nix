{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.vim;
in
{
  options.programs.vim = {
    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        When enabled, installs vim and configures vim to be the default editor
        using the EDITOR environment variable.
      '';
    };

    package = lib.mkPackageOption pkgs "vim" {
      example = "vim-full";
    };
  };

  config = lib.mkIf cfg.defaultEditor {
    environment.systemPackages = [ cfg.package ];
    environment.variables = {
      EDITOR = lib.mkOverride 900 "vim";
    };
  };
}
