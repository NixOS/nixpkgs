{lib, pkgs, config, ...}:

with lib;
let
  inherit (lib) mkOption mkIf;
  wmcfg = config.services.xserver.windowManager;
in

{
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "openbox" ]);
    };
  };

  config = mkIf (elem "openbox" wmcfg.select) {
    services.xserver.windowManager = {
      session = [{
        name = "openbox";
        start = "
          ${pkgs.openbox}/bin/openbox-session
        ";
      }];
    };
    environment.systemPackages = [ pkgs.openbox ];
  };
}
