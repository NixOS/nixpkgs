{ config , lib , pkgs , ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.e16;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.e16.enable = mkEnableOption (lib.mdDoc "e16");
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "E16";
      start = ''
        ${pkgs.e16}/bin/e16 &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ pkgs.e16 ];
  };
}
