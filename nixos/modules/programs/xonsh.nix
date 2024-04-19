{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.xonsh;
in

{
  meta = {
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };

  options = {
    programs.xonsh = {
      enable = lib.mkEnableOption "xonsh";

      package = lib.mkPackageOption pkgs "xonsh" {
        example = ''
          let
            python3Packages = pkgs.python312Packages;
            xonsh = pkgs.xonsh.override { inherit python3Packages; };
          in xonsh.wrapper.override {
            inherit xonsh;
            extraPackages = ps: with ps; [ requests ];
          }
        '';
      };

      config = lib.mkOption {
        default = "";
        description = "Control file to customize your shell behavior.";
        type = lib.types.lines;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."xonsh/xonshrc".text = ''
      # /etc/xonsh/xonshrc: machine-generated - DO NOT EDIT!

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

    environment.shells = [
      "/run/current-system/sw/bin/xonsh"
      "${lib.getExe cfg.package}"
    ];
  };
}
