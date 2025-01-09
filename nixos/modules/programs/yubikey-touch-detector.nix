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
    services.yubikey-touch-detector = cfg;

    warnings = [
      ''
        The module programs.yubikey-touch-detector is deprecated.
        Please use services.yubikey-touch-detector instead.
      ''
    ];
  };
}
