# This module defines global configuration for the xonsh.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.xonsh;

in

{

  options = {

    programs.xonsh = {

      enable = mkOption {
        default = false;
        description = lib.mdDoc ''
          Whether to configure xonsh as an interactive shell.
        '';
        type = types.bool;
      };

      package = mkOption {
        type = types.package;
        default = pkgs.xonsh;
        defaultText = literalExpression "pkgs.xonsh";
        example = literalExpression "pkgs.xonsh.override { configFile = \"/path/to/xonshrc\"; }";
        description = lib.mdDoc ''
          xonsh package to use.
        '';
      };

      config = mkOption {
        default = "";
        description = lib.mdDoc "Control file to customize your shell behavior.";
        type = types.lines;
      };

    };

  };

  config = mkIf cfg.enable {

    environment.etc."xonsh/xonshrc".text = ''
      # /etc/xonsh/xonshrc: DO NOT EDIT -- this file has been generated automatically.


      if not ''${...}.get('__NIXOS_SET_ENVIRONMENT_DONE'):
          # The NixOS environment and thereby also $PATH
          # haven't been fully set up at this point. But
          # `source-bash` below requires `bash` to be on $PATH,
          # so add an entry with bash's location:
          $PATH.add('${pkgs.bash}/bin')

          # Stash xonsh's ls alias, so that we don't get a collision
          # with Bash's ls alias from environment.shellAliases:
          _ls_alias = aliases.pop('ls', None)

          # Source the NixOS environment config.
          source-bash "${config.system.build.setEnvironment}"

          # Restore xonsh's ls alias, overriding that from Bash (if any).
          if _ls_alias is not None:
              aliases['ls'] = _ls_alias
          del _ls_alias


      ${cfg.config}
    '';

    environment.systemPackages = [ cfg.package ];

    environment.shells =
      [ "/run/current-system/sw/bin/xonsh"
        "${cfg.package}/bin/xonsh"
      ];

  };

}

