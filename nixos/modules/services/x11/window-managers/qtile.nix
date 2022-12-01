{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.qtile;
in

{
  options.services.xserver.windowManager.qtile = {
    enable = mkEnableOption (lib.mdDoc "qtile");

    package = mkPackageOption pkgs "qtile" { };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = [{
      name = "qtile";
      start = ''
        ${cfg.package}/bin/qtile start &
        waitPID=$!
      '';
    }];

    environment.systemPackages = [
      # pkgs.qtile is currently a buildenv of qtile and its dependencies.
      # For userland commands, we want the underlying package so that
      # packages such as python don't bleed into userland and overwrite intended behavior.
      (cfg.package.unwrapped or cfg.package)
    ];
  };
}
