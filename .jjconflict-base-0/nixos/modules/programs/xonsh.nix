# This module defines global configuration for the xonsh.

{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.programs.xonsh;
  package = cfg.package.override { inherit (cfg) extraPackages; };
  bashCompletionPath = "${cfg.bashCompletion.package}/share/bash-completion/bash_completion";
in

{

  options = {

    programs.xonsh = {

      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to configure xonsh as an interactive shell.
        '';
        type = lib.types.bool;
      };

      package = lib.mkPackageOption pkgs "xonsh" {
        extraDescription = ''
          The argument `extraPackages` of this package will be overridden by
          the option `programs.xonsh.extraPackages`.
        '';
      };

      config = lib.mkOption {
        default = "";
        description = ''
          Extra text added to the end of `/etc/xonsh/xonshrc`,
          the system-wide control file for xonsh.
        '';
        type = lib.types.lines;
      };

      extraPackages = lib.mkOption {
        default = (ps: [ ]);
        defaultText = lib.literalExpression "ps: [ ]";
        example = lib.literalExpression ''
          ps: with ps; [ numpy xonsh.xontribs.xontrib-vox ]
        '';
        type =
          with lib.types;
          coercedTo (listOf lib.types.package) (v: (_: v)) (functionTo (listOf lib.types.package));
        description = ''
          Xontribs and extra Python packages to be available in xonsh.
        '';
      };

      bashCompletion = {
        enable = lib.mkEnableOption "bash completions for xonsh" // {
          default = true;
        };
        package = lib.mkPackageOption pkgs "bash-completion" { };
      };
    };

  };

  config = lib.mkIf cfg.enable {

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

      ${lib.optionalString cfg.bashCompletion.enable "$BASH_COMPLETIONS = '${bashCompletionPath}'"}

      ${cfg.config}
    '';

    environment.systemPackages = [ package ];

    environment.shells = [
      "/run/current-system/sw/bin/xonsh"
      "${lib.getExe package}"
    ];
  };
}
