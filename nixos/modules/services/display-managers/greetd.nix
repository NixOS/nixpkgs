{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.greetd;
  tty = "tty${toString cfg.vt}";
  settingsFormat = pkgs.formats.toml {};
in
{
  options.services.greetd = {
    enable = mkEnableOption (lib.mdDoc "greetd");

    package = mkOption {
      type = types.package;
      default = pkgs.greetd.greetd;
      defaultText = literalExpression "pkgs.greetd.greetd";
      description = lib.mdDoc "The greetd package that should be used.";
    };

    settings = mkOption {
      type = settingsFormat.type;
      example = literalExpression ''
        {
          default_session = {
            command = "''${pkgs.greetd.greetd}/bin/agreety --cmd sway";
          };
        }
      '';
      description = lib.mdDoc ''
        greetd configuration ([documentation](https://man.sr.ht/~kennylevinsen/greetd/))
        as a Nix attribute set.
      '';
    };

    vt = mkOption  {
      type = types.int;
      default = 1;
      description = lib.mdDoc ''
        The virtual console (tty) that greetd should use. This option also disables getty on that tty.
      '';
    };

    restart = mkOption {
      type = types.bool;
      default = !(cfg.settings ? initial_session);
      defaultText = literalExpression "!(config.services.greetd.settings ? initial_session)";
      description = lib.mdDoc ''
        Wether to restart greetd when it terminates (e.g. on failure).
        This is usually desirable so a user can always log in, but should be disabled when using 'settings.initial_session' (autologin),
        because every greetd restart will trigger the autologin again.
      '';
    };
  };
  config = mkIf cfg.enable {

    services.greetd.settings.terminal.vt = mkDefault cfg.vt;
    services.greetd.settings.default_session.user = mkDefault "greeter";

    security.pam.services.greetd = {
      allowNullPassword = true;
      startSession = true;
    };

    # This prevents nixos-rebuild from killing greetd by activating getty again
    systemd.services."autovt@${tty}".enable = false;

    systemd.services.greetd = {
      unitConfig = {
        Wants = [
          "systemd-user-sessions.service"
        ];
        After = [
          "systemd-user-sessions.service"
          "plymouth-quit-wait.service"
          "getty@${tty}.service"
        ];
        Conflicts = [
          "getty@${tty}.service"
        ];
      };

      serviceConfig = {
        ExecStart = "${pkgs.greetd.greetd}/bin/greetd --config ${settingsFormat.generate "greetd.toml" cfg.settings}";

        Restart = mkIf cfg.restart "always";

        # Defaults from greetd upstream configuration
        IgnoreSIGPIPE = false;
        SendSIGHUP = true;
        TimeoutStopSec = "30s";
        KeyringMode = "shared";
      };

      # Don't kill a user session when using nixos-rebuild
      restartIfChanged = false;

      wantedBy = [ "graphical.target" ];
    };

    systemd.defaultUnit = "graphical.target";

    users.users.greeter = {
      isSystemUser = true;
      group = "greeter";
    };

    users.groups.greeter = {};
  };

  meta.maintainers = with maintainers; [ queezle ];
}
