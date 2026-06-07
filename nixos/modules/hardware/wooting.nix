{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.wooting;
in
{
  options.hardware.wooting = {
    enable = lib.mkEnableOption "support for Wooting keyboards";
    background-service.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Support for Wootility background service.
        Don't forget to enable it in the Wootility app.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.wootility
    ]
    ++ lib.optional cfg.background-service.enable pkgs.wooting-bg-service;
    services.udev.packages = lib.optional pkgs.stdenv.isLinux pkgs.wooting-udev-rules;
  };
}
