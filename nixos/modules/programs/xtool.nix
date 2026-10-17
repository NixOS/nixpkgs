{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.xtool;
in
{
  options.programs.xtool = {
    enable = lib.mkEnableOption "xtool, with usbmuxd for access to iOS devices";
    package = lib.mkPackageOption pkgs "xtool" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.usbmuxd.enable = true;
  };

  meta.maintainers = pkgs.xtool.meta.maintainers;
}
