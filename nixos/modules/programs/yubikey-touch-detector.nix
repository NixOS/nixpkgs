{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  cfg = config.programs.yubikey-touch-detector;
in
{
  options = {
    programs.yubikey-touch-detector = {

      enable = lib.mkEnableOption "yubikey-touch-detector";

      libnotify = lib.mkOption {
        # This used to be true previously and using libnotify would be a sane default.
        default = true;
        type = types.bool;
        description = ''
          If set to true, yubikey-touch-detctor will send notifications using libnotify
        '';
      };

      unixSocket = lib.mkOption {
        default = true;
        type = types.bool;
        description = ''
          If set to true, yubikey-touch-detector will send notifications to a unix socket
        '';
      };

      verbose = lib.mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enables verbose logging
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ pkgs.yubikey-touch-detector ];

    systemd.user.services.yubikey-touch-detector = {
      path = [ pkgs.gnupg ];

      environment = {
        YUBIKEY_TOUCH_DETECTOR_LIBNOTIFY = builtins.toString cfg.libnotify;
        YUBIKEY_TOUCH_DETECTOR_NOSOCKET = builtins.toString (!cfg.unixSocket);
        YUBIKEY_TOUCH_DETECTOR_VERBOSE = builtins.toString cfg.verbose;
      };

      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
    };
    systemd.user.sockets.yubikey-touch-detector = {
      wantedBy = [ "sockets.target" ];
    };
  };
}
