{ config, lib, pkgs, ... }:

let
  inherit (lib) mdDoc mkEnableOption mkIf mkPackageOptionMD singleton;
  cfg = config.services.xserver.windowManager.katriawm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.katriawm = {
      enable = mkEnableOption (mdDoc "katriawm");
      package = mkPackageOptionMD pkgs "katriawm" {};
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "katriawm";
      start = ''
        ${cfg.package}/bin/katriawm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
