{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.ragnarwm;
in
{
  ###### interface

  options = {
    services.xserver.windowManager.ragnarwm = {
      enable = lib.mkEnableOption "ragnarwm";
      package = lib.mkPackageOption pkgs "ragnarwm" { };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    services.displayManager.sessionPackages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ sigmanificient ];
}
