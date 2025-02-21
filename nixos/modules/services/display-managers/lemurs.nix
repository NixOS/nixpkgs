{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.lemurs;
  tty = "tty${toString cfg.vt}";
  settingsFormat = pkgs.formats.toml { };
in
{
  options.services.lemurs = {
    enable = lib.mkEnableOption "lemurs, a customizable TUI display/login manager";

    package = lib.mkPackageOption pkgs "lemurs" { };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      example = lib.literalExpression ''
        {
          do_log = true;
        }
      '';
      description = ''
        lemurs configuration ([documentation](https://github.com/coastalwhite/lemurs/blob/main/extra/config.toml))
        as a Nix attribute set.
      '';
    };

    vt = lib.mkOption {
      type = lib.types.int;
      default = 2;
      description = ''
        The virtual console (tty) that lemurs should use. This option also disables getty on that tty.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    # needed so "services.displayManager.sessionData.desktops" is defined
    services.displayManager.enable = true;

    security.pam.services.lemurs = {
      allowNullPassword = true;
      startSession = true;
      # See https://github.com/coastalwhite/lemurs/issues/166
      setLoginUid = false;
      enableGnomeKeyring = lib.mkDefault config.services.gnome.gnome-keyring.enable;
    };

    # set default settings
    services.lemurs.settings =
      let
        sessionData = config.services.displayManager.sessionData.desktops;
      in
      {
        tty = lib.mkDefault cfg.vt;
        system_shell = lib.mkDefault "${pkgs.bash}/bin/bash";
        xsessions_path = lib.mkDefault "${sessionData}/share/xsessions";
        wayland_sessions_path = lib.mkDefault "${sessionData}/share/wayland-sessions";
      };

    systemd.services.lemurs = {
      description = "Lemurs";
      aliases = [ "display-manager.service" ];

      unitConfig = {
        Wants = [ "systemd-user-sessions.service" ];
        After = [
          "systemd-user-sessions.service"
          "getty@${tty}.service"
          "plymouth-quit-wait.service"
        ];
        Conflicts = [ "getty@${tty}.service" ];
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/lemurs --config ${settingsFormat.generate "config.toml" cfg.settings}";

        # Defaults from lemurs upstream configuration
        StandardInput = "tty";
        TTYPath = "/dev/${tty}";
        TTYReset = "yes";
        TTYVHangup = "yes";

        Type = "idle";
      };

      # Don't kill a user session when using nixos-rebuild
      restartIfChanged = false;

      wantedBy = [ "graphical.target" ];
    };

    systemd.defaultUnit = "graphical.target";
  };

  meta.maintainers = with lib.maintainers; [ stunkymonkey ];
}
