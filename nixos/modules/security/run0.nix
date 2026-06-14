{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    ;

  cfg = config.security.run0;

  sudoAlias = pkgs.writeShellScriptBin "sudo" ''
    if [[ "$1" == -* ]]; then
      echo "This script is a sudo-alias to systemd's run0 and does not support any sudo parameters."
      exit 1
    fi
    exec run0 "$@"
  '';
in
{
  options.security.run0 = {
    enable = mkEnableOption "support for run0";

    wheelNeedsPassword = mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether users of the `wheel` group must
        provide a password to run commands as super user via {command}`run0`.
      '';
    };

    enableSudoAlias = mkEnableOption "make {command}`sudo` an alias to {command}`run0`.";
  };

  config = mkMerge [
    {
      # Late introduction of the enable toggle, this should help during migration.
      # TODO: Remove after 26.11 release
      assertions = [
        {
          assertion = !cfg.wheelNeedsPassword -> cfg.enable;
          message = "`security.run0.enable` is currently disabled, but is required for the `security.run0.wheelNeedsPassword` option to take effect";
        }
        {
          assertion = cfg.enableSudoAlias -> cfg.enable;
          message = "`security.run0.enableSudoAlias` depends on `security.run0.enable`, which is disabled.";
        }
      ];
    }
    (mkIf cfg.enable {
      assertions = [
        {
          assertion =
            cfg.enableSudoAlias -> (!config.security.sudo.enable && !config.security.sudo-rs.enable);
          message = "`security.run0.enableSudoAlias` cannot be enabled if `security.sudo` or `security.sudo-rs` are enabled.";
        }
      ];

      security.polkit = {
        enable = true;
        extraConfig = mkIf (!cfg.wheelNeedsPassword) ''
          polkit.addRule(function(action, subject) {
            if (action.id == "org.freedesktop.systemd1.manage-units" && subject.isInGroup("wheel")) {
              return polkit.Result.YES;
            }
          });
        '';
      };

      environment.systemPackages = lib.optional cfg.enableSudoAlias sudoAlias;
    })
  ];
}
