{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.programs.zoom-us.enable = lib.mkEnableOption "zoom.us video conferencing application";
  config.environment.systemPackages = lib.mkIf config.programs.zoom-us.enable (
    lib.singleton (
      pkgs.zoom-us.override {
        pulseaudioSupport = config.services.pulseaudio.enable;
        xdgDesktopPortalPkgs = lib.const (
          lib.optionals config.xdg.portal.enable config.xdg.portal.extraPortals
        );
      }
    )
  );
}
