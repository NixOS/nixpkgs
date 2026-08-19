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
    mkPackageOption
    mkAliasOptionModule
    optionalString
    ;

  cfg = config.security.run0;
in
{
  options.security.run0 = {
    enable = mkEnableOption "support for run0";

    persistentAuth.enable = mkEnableOption ''
      persistent authentication for sessions.
      Timeout configurable via {option}`security.polkit.settings.Polkitd.ExpirationSeconds`
    '';
    persistentAuth.enableRemote = mkEnableOption "persistent authentication for remote sessions";

    wheelNeedsPassword = mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether users of the `wheel` group must
        provide a password to run commands as super user via {command}`run0`.
      '';
    };

    sudo-shim.enable = mkEnableOption "make {command}`sudo` an alias to {command}`run0`.";
    sudo-shim.package = mkPackageOption pkgs "run0-sudo-shim" { };
  };

  imports = [
    (mkAliasOptionModule
      [ "security" "run0" "enableSudoAlias" ]
      [ "security" "run0" "sudo-shim" "enable" ]
    )
  ];

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
            cfg.sudo-shim.enable -> (!config.security.sudo.enable && !config.security.sudo-rs.enable);
          message = "`security.run0.sudo-shim.enable` cannot be enabled if `security.sudo` or `security.sudo-rs` are enabled.";
        }
      ];

      security.polkit = {
        enable = true;
        extraConfig = lib.concatLines [
          (optionalString (!cfg.wheelNeedsPassword) ''
            polkit.addRule(function(action, subject) {
              if (action.id == "org.freedesktop.systemd1.manage-units" && subject.isInGroup("wheel")) {
                return polkit.Result.YES;
              }
            });
          '')
          (optionalString cfg.persistentAuth.enable ''
            polkit.addRule(function(action, subject) {
              if (action.id == "org.freedesktop.systemd1.manage-units" && subject.active ${
                optionalString (!cfg.persistentAuth.enableRemote) "&& subject.local"
              }) {
                return polkit.Result.AUTH_ADMIN_KEEP;
              }
            });
          '')
        ];
      };

      environment.systemPackages = lib.optional cfg.sudo-shim.enable cfg.sudo-shim.package;
    })
  ];

  meta = {
    maintainers = with lib.maintainers; [
      zimward
      grimmauld
      kuflierl
    ];
  };
}
