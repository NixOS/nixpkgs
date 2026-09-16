# adapted from upstream
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.displayManager.noctalia-greeter;
  format = pkgs.formats.toml { };

  inherit (lib)
    escapeShellArgs
    getExe'
    maintainers
    mkAfter
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    optionalAttrs
    ;

  inherit (lib.types)
    listOf
    str
    ;
in
{
  options.services.displayManager.noctalia-greeter = {
    enable = mkEnableOption "Noctalia Greeter, a minimal login greeter for greetd";

    package = mkPackageOption pkgs "noctalia-greeter" { };

    extraArgs = mkOption {
      description = "Arguments to add to the noctalia-greeter-session invocation.";
      type = listOf str;
      default = [ ];
    };

    settings = mkOption {
      description = ''
        Settings for noctalia-greeter written to greeter.toml.

        Note that it also can contain some state, like the most recently used
        session, which will be clobbered on every activation and boot. This is
        due to an upstream limitation; the state is due to be moved to another
        file.
      '';
      inherit (format) type;
      default = { };
      example = {
        cursor = {
          theme = "Adwaita";
          size = 24;
        };
        keyboard = {
          layout = "us";
        };
      };
    };

    cursorTheme = {
      package = mkPackageOption pkgs "cursor theme" {
        nullable = true;
        default = null;
      };

      name = mkOption {
        type = str;
        default = "Adwaita";
        description = ''
          Name of the cursor theme to use for noctalia-greeter.
        '';
      };
    };

    passwordless-sync-users = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Local users allowed to apply the constrained appearance-only sync through
        Polkit without authentication. The constrained sync operation never accepts
        session command configuration. Leave empty to require administrator
        authentication for every sync; that workflow remains fully supported.
      '';
      example = [ "alice" ];
    };
  };

  config =
    let
      user = config.services.greetd.settings.default_session.user;
      group =
        let
          g = config.users.users.${user}.group or "";
        in
        if g != "" then g else "greeter";
    in
    mkMerge [
      (mkIf cfg.enable {
        assertions = [
          {
            assertion = (config.users.users.${user} or { }) != { };
            message = "noctalia-greeter: user ${user} does not exist. Please create it before referencing it.";
          }
          {
            assertion = lib.all (name: builtins.hasAttr name config.users.users) cfg.passwordless-sync-users;
            message = "noctalia-greeter: every passwordless sync user must be a configured system user.";
          }
        ];

        services.displayManager.noctalia-greeter.settings.cursor = mkIf (cfg.cursorTheme.package != null) {
          theme = mkDefault cfg.cursorTheme.name;
          path = mkDefault "${cfg.cursorTheme.package}/share/icons";
        };

        environment.systemPackages = [ cfg.package ];

        systemd.tmpfiles.settings."10-noctalia-greeter" = {
          "/var/lib/noctalia-greeter".d = {
            inherit user group;
            mode = "0750";
          };
        }
        // optionalAttrs (cfg.settings != { }) {
          "/var/lib/noctalia-greeter/greeter.toml"."L+" = {
            argument = "${format.generate "greeter.toml" cfg.settings}";
            inherit user group;
            mode = "0644";
          };
        };

        services.greetd = {
          enable = mkDefault true;
          settings.default_session.command = mkDefault "${getExe' cfg.package "noctalia-greeter-session"} ${escapeShellArgs cfg.extraArgs}";
        };

        security.polkit.enable = mkDefault true;
        services.accounts-daemon.enable = mkDefault true;
      })

      (mkIf (cfg.enable && cfg.passwordless-sync-users != [ ]) {
        security.polkit.extraConfig = mkAfter ''
          polkit.addRule(function(action, subject) {
            var allowedUsers = ${builtins.toJSON cfg.passwordless-sync-users};
            if (action.id == "org.noctalia.greeter.sync-appearance" &&
                action.lookup("program") == "${cfg.package}/bin/noctalia-greeter-apply-appearance" &&
                action.lookup("user") == "root" &&
                subject.local && subject.active &&
                allowedUsers.indexOf(subject.user) >= 0) {
              return polkit.Result.YES;
            }
          });
        '';
      })
    ];

  meta.maintainers = with maintainers; [
    dtomvan
    samiser
  ];
}
