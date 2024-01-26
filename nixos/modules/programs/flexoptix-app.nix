{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.flexoptix-app;
in {
  options = {
    programs.flexoptix-app = {
      enable = mkEnableOption (lib.mdDoc "FLEXOPTIX app + udev rules");

      package = mkPackageOption pkgs "flexoptix-app" { };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };
}
