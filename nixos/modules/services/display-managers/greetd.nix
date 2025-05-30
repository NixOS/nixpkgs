{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.greetd;
  tty = "tty${toString cfg.vt}";
  settingsFormat = pkgs.formats.toml { };
in
{
  options.services.greetd = {
    enable = lib.mkEnableOption "greetd, a minimal and flexible login manager daemon";

    package = lib.mkPackageOption pkgs [ "greetd" "greetd" ] { };

    settings = lib.mkOption {
      type = settingsFormat.type;
      example = lib.literalExpression ''
        {
          default_session = {
            command = "''${pkgs.greetd.greetd}/bin/agreety --cmd sway";
          };
        }
      '';
      description = ''
        greetd configuration ([documentation](https://man.sr.ht/~kennylevinsen/greetd/))
        as a Nix attribute set.
      '';
    };

    greeterManagesPlymouth = lib.mkOption {
      type = lib.types.bool;
      internal = true;
      default = false;
      description = ''
        Don't configure the greetd service to wait for Plymouth to exit.

        Enable this if the greeter you're using can manage Plymouth itself to provide a smoother handoff.
      '';
    };

    vt = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = ''
        The virtual console (tty) that greetd should use. This option also disables getty on that tty.
      '';
    };

    restart = lib.mkOption {
      type = lib.types.bool;
      default = !(cfg.settings ? initial_session);
      defaultText = lib.literalExpression "!(config.services.greetd.settings ? initial_session)";
      description = ''
        Whether to restart greetd when it terminates (e.g. on failure).
        This is usually desirable so a user can always log in, but should be disabled when using 'settings.initial_session' (autologin),
        because every greetd restart will trigger the autologin again.
      '';
    };
  };
  config = lib.mkIf cfg.enable {

    services.greetd.settings.terminal.vt = lib.mkDefault cfg.vt;
    services.greetd.settings.default_session.user = lib.mkDefault "greeter";

    security.pam.services.greetd = {
      allowNullPassword = true;
      startSession = true;
      enableGnomeKeyring = lib.mkDefault config.services.gnome.gnome-keyring.enable;
    };

    # This prevents nixos-rebuild from killing greetd by activating getty again
    systemd.services."autovt@${tty}".enable = false;

    # Enable desktop session data
    services.displayManager.enable = lib.mkDefault true;

    systemd.services.greetd = {
      aliases = [ "display-manager.service" ];

      unitConfig = {
        Wants = [
          "systemd-user-sessions.service"
        ];
        After =
          [
            "systemd-user-sessions.service"
            "getty@${tty}.service"
          ]
          ++ lib.optionals (!cfg.greeterManagesPlymouth) [
            "plymouth-quit-wait.service"
          ];
        Conflicts = [
          "getty@${tty}.service"
        ];
      };

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --config ${settingsFormat.generate "greetd.toml" cfg.settings}";

        Restart = lib.mkIf cfg.restart "on-success";

        # Defaults from greetd upstream configuration
        IgnoreSIGPIPE = false;
        SendSIGHUP = true;
        TimeoutStopSec = "30s";
        KeyringMode = "shared";

        Type = "idle";
      };

      # Don't kill a user session when using nixos-rebuild
      restartIfChanged = false;

      wantedBy = [ "graphical.target" ];
    };

    systemd.defaultUnit = "graphical.target";

    # Create directories potentially required by supported greeters
    # See https://github.com/NixOS/nixpkgs/issues/248323
    systemd.tmpfiles.rules = [
      "d '/var/cache/tuigreet' - greeter greeter - -"
    ];

    users.users.greeter = {
      isSystemUser = true;
      group = "greeter";
    };

    users.groups.greeter = { };
  };

  meta.maintainers = with lib.maintainers; [ queezle ];
}
