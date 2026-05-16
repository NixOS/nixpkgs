{
  config,
  lib,
  pkgs,
  ...
}:

let
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
    wheelNeedsPassword = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether users of the `wheel` group must
        provide a password to run commands as super user via {command}`run0`.
      '';
    };

    enableSudoAlias = lib.mkEnableOption "make {command}`sudo` an alias to {command}`run0`.";
  };

  config = {
    assertions = [
      {
        assertion =
          cfg.enableSudoAlias -> (!config.security.sudo.enable && !config.security.sudo-rs.enable);
        message = "`security.run0.enableSudoAlias` cannot be enabled if `security.sudo` or `security.sudo-rs` are enabled.";
      }
    ];

    security.polkit.extraConfig = lib.mkIf (!cfg.wheelNeedsPassword) ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" && subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';

    environment.systemPackages = lib.optional cfg.enableSudoAlias sudoAlias;
  };
}
