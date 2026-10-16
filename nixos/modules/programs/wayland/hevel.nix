{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.hevel;
in
{
  options.programs.hevel = {
    enable = lib.mkEnableOption ''
      hevel, a scrollable, floating window manager for Wayland.
      Launch it by running "swc-launch hevel" on a TTY
    '';

    package = lib.mkPackageOption pkgs "hevel" {
      example = ''
        pkgs.hevel.override {
          conf = ./config.h;
        }
      '';
    };

    swcPackage = lib.mkPackageOption pkgs "neuswc" {
      extraDescription = ''
        It provides {command}`swc-launch`, which opens the TTY and input
        devices as root and then starts hevel without privileges.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.swc-launch = {
      setuid = true;
      owner = "root";
      group = "root";
      source = lib.getExe' cfg.swcPackage "swc-launch";
    };

    hardware.graphics.enable = lib.mkDefault true;
  };

  meta.maintainers = with lib.maintainers; [
    ricardomaps
    yiyu
  ];
}
