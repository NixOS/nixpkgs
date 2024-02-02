{ config, lib, pkgs, ... }:

with lib; let
  cfg = config.programs.xppen;
in

{
  options.programs.xppen = {
    enable = mkEnableOption (lib.mdDoc "XPPen PenTablet application");
    package = mkPackageOption pkgs "xppen" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    services.udev.packages = [ cfg.package ];
  };
}
