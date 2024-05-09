{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.surf-display;

  surfDisplayConf = ''
    # Surf Kiosk Display: Wrap around surf browser and turn your
    # system into a browser screen in KIOSK-mode.

    # default download URI for all display screens if not configured individually
    DEFAULT_WWW_URI="${cfg.defaultWwwUri}"

    # Enforce fixed resolution for all displays (default: not set):
    #DEFAULT_RESOLUTION="1920x1080"

    # HTTP proxy URL, if needed (default: not set).
    #HTTP_PROXY_URL="http://webcache:3128"

    # Setting for internal inactivity timer to restart surf-display
    # if the user goes inactive/idle.
    INACTIVITY_INTERVAL="${builtins.toString cfg.inactivityInterval}"

    # log to syslog instead of .xsession-errors
    LOG_TO_SYSLOG="yes"

    # Launch pulseaudio daemon if not already running.
    WITH_PULSEAUDIO="yes"

    # screensaver settings, see "man 1 xset" for possible options
    SCREENSAVER_SETTINGS="${cfg.screensaverSettings}"

    # disable right and middle pointer device click in browser sessions while keeping
    # scrolling wheels' functionality intact... (consider "pointer" subcommand on
    # xmodmap man page for details).
    POINTER_BUTTON_MAP="${cfg.pointerButtonMap}"

    # Hide idle mouse pointer.
    HIDE_IDLE_POINTER="${cfg.hideIdlePointer}"

    ${cfg.extraConfig}
  '';

in {
  options = {
    services.xserver.desktopManager.surf-display = {
      enable = mkEnableOption "surf-display as a kiosk browser session";

      defaultWwwUri = mkOption {
        type = types.str;
        default = "${pkgs.surf-display}/share/surf-display/empty-page.html";
        defaultText = literalExpression ''"''${pkgs.surf-display}/share/surf-display/empty-page.html"'';
        example = "https://www.example.com/";
        description = "Default URI to display.";
      };

      inactivityInterval = mkOption {
        type = types.int;
        default = 300;
        example = 0;
        description = ''
          Setting for internal inactivity timer to restart surf-display if the
          user goes inactive/idle to get a fresh session for the next user of
          the kiosk.

          If this value is set to zero, the whole feature of restarting due to
          inactivity is disabled.
        '';
      };

      screensaverSettings = mkOption {
        type = types.separatedString " ";
        default = "";
        description = ''
          Screensaver settings, see `man 1 xset` for possible options.
        '';
      };

      pointerButtonMap = mkOption {
        type = types.str;
        default = "1 0 0 4 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
        description = ''
          Disable right and middle pointer device click in browser sessions
          while keeping scrolling wheels' functionality intact. See pointer
          subcommand on `man xmodmap` for details.
        '';
      };

      hideIdlePointer = mkOption {
        type = types.str;
        default = "yes";
        example = "no";
        description = "Hide idle mouse pointer.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          # Enforce fixed resolution for all displays (default: not set):
          DEFAULT_RESOLUTION="1920x1080"

          # HTTP proxy URL, if needed (default: not set).
          HTTP_PROXY_URL="http://webcache:3128"

          # Configure individual display screens with host specific parameters:
          DISPLAYS['display-host-0']="www_uri=https://www.displayserver.comany.net/display-1/index.html"
          DISPLAYS['display-host-1']="www_uri=https://www.displayserver.comany.net/display-2/index.html"
          DISPLAYS['display-host-2']="www_uri=https://www.displayserver.comany.net/display-3/index.html|res=1920x1280"
          DISPLAYS['display-host-3']="www_uri=https://www.displayserver.comany.net/display-4/index.html"|res=1280x1024"
          DISPLAYS['display-host-local-file']="www_uri=file:///usr/share/doc/surf-display/empty-page.html"
        '';
        description = ''
          Extra configuration options to append to `/etc/default/surf-display`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.displayManager.sessionPackages = [
      pkgs.surf-display
    ];

    environment.etc."default/surf-display".text = surfDisplayConf;
  };
}
