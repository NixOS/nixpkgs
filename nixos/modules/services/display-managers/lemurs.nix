{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.displayManager.lemurs;
  settingsFormat = pkgs.formats.toml { };
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "displayManager"
      "lemurs"
      "vt"
    ] "The VT is now fixed to VT1.")
  ];

  options.services.displayManager.lemurs = {
    enable = lib.mkEnableOption "" // {
      description = ''
        Whether to enable lemurs, a customizable TUI display/login manager.

        ::: {.note}
        For Wayland compositors, your user must be in the "seat" group.
        :::
      '';
    };

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
        Configuration for lemurs, provided as a Nix attribute set and automatically
        serialized to TOML.
        See [lemurs configuration documentation](https://github.com/coastalwhite/lemurs/blob/main/extra/config.toml) for available options.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.services.displayManager.autoLogin.enable;
        message = ''
          lemurs doesn't support auto login.
        '';
      }
    ];

    security.pam.services.lemurs = {
      unixAuth = true;
      startSession = true;
      # See https://github.com/coastalwhite/lemurs/issues/166
      setLoginUid = false;
      enableGnomeKeyring = lib.mkDefault config.services.gnome.gnome-keyring.enable;
    };

    environment.systemPackages = [ cfg.package ];

    services = {
      dbus.packages = [ cfg.package ];
      # Required for wayland with setLoginUid = false;
      seatd.enable = true;
      xserver = {
        # To enable user switching, allow lemurs to allocate displays dynamically.
        display = null;
      };
      displayManager = {
        enable = true;
        execCmd = "exec ${lib.getExe cfg.package} --config ${settingsFormat.generate "config.toml" cfg.settings}";
        # set default settings
        lemurs.settings =
          let
            desktops = config.services.displayManager.sessionData.desktops;
          in
          {
            tty = 1;
            system_shell = lib.mkDefault "${pkgs.bash}/bin/bash";
            initial_path = lib.mkDefault "/run/current-system/sw/bin";
            x11 = {
              xauth_path = lib.mkDefault "${pkgs.xorg.xauth}/bin/xauth";
              xserver_path = lib.mkDefault "${pkgs.xorg.xorgserver}/bin/X";
              xsessions_path = lib.mkDefault "${desktops}/share/xsessions";
              xsetup_path = lib.mkDefault config.services.displayManager.sessionData.wrapper;
            };
            wayland.wayland_sessions_path = lib.mkDefault "${desktops}/share/wayland-sessions";
          };
      };
    };

    systemd.services.display-manager = {
      unitConfig = {
        Wants = [ "systemd-user-sessions.service" ];
        After = [
          "systemd-user-sessions.service"
          "plymouth-quit-wait.service"
        ];
      };
      serviceConfig = {
        Type = "idle";
        # Defaults from lemurs upstream configuration
        StandardInput = "tty";
        TTYPath = "/dev/tty1";
        TTYReset = "yes";
        TTYVHangup = "yes";
        # Clear the console before starting
        TTYVTDisallocate = true;
      };
      # Don't kill a user session when using nixos-rebuild
      restartIfChanged = false;
    };
  };

  meta.maintainers = with lib.maintainers; [
    nullcube
    stunkymonkey
  ];
}
