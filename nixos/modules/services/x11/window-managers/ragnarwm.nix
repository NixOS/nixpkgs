{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.ragnarwm;
in
{
  ###### interface

  options = {
    services.xserver.windowManager.ragnarwm = {
      enable = mkEnableOption (lib.mdDoc "ragnarwm");
      package = mkPackageOption pkgs "ragnarwm" { };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    services.xserver.displayManager.sessionPackages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ sigmanificient ];
}
