{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.displayManager.emptty;
  desktops = config.services.displayManager.sessionData.desktops;

  settingsFormat =
    name: settings:
    pkgs.writeText name ''
      ${lib.concatMapAttrsStringSep "\n" (
        n: v:
        if lib.isString v || lib.isPath v then
          "${n}=${v}"
        else if lib.isInt v then
          "${n}=${toString v}"
        else if lib.isBool v then
          "${n}=${if v then "true" else "false"}"
        else
          ""
      ) settings}
    '';
in
{
  options = {
    services.displayManager.emptty = {
      enable = lib.mkEnableOption "emptty as the display manager";

      package = lib.mkPackageOption pkgs [ "emptty" ] { };

      settings = lib.mkOption {
        type =
          with lib.types;
          attrsOf (
            nullOr (oneOf [
              str
              int
              bool
              path
            ])
          );
        default = { };
        description = ''
          Configuration for emptty, provided as a Nix attribute set and automatically
          serialized to simple key-value pair.
          See [emptty configuration documentation](https://github.com/tvrzna/emptty/blob/master/README.md) for available options.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security.pam.services = {
      emptty = {
        unixAuth = true;
        startSession = true;
        enableGnomeKeyring = lib.mkDefault config.services.gnome.gnome-keyring.enable;
      };
    };

    environment.systemPackages = [ cfg.package ];

    services = {
      dbus.packages = [ cfg.package ];
      xserver = {
        display = null;
      };
      displayManager = {
        enable = true;
        generic = {
          enable = true;
          execCmd = "exec ${lib.getExe cfg.package} --daemon --config ${settingsFormat "config" cfg.settings}";
        };
        emptty = {
          settings = {
            TTY_NUMBER = 1;
            SWITCH_TTY = lib.mkDefault true;
            XORG_ARGS = toString config.services.xserver.displayManager.xserverArgs;
            XORG_SESSIONS_PATH = "${desktops}/share/xsessions";
            WAYLAND_SESSIONS_PATH = "${desktops}/share/wayland-sessions";
          };
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
        StandardInput = "tty";
        TTYPath = "/dev/tty${toString cfg.settings.TTY_NUMBER or 1}";
        TTYReset = "yes";
        TTYVHangup = "yes";
        TTYVTDisallocate = true;
        KillMode = "process";
        IgnoreSIGPIPE = "no";
        SendSIGHUP = "yes";
      };
      restartIfChanged = false;
    };
  };
}
