{lib, pkgs, config, ...}:

with lib;
let
  wmcfg = config.services.xserver.windowManager;
in

{
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "windowlab" ]);
    };
  };

  config = mkIf (elem "windowlab" wmcfg.select) {
    services.xserver.windowManager = {
      session =
        [{ name  = "windowlab";
           start = "${pkgs.windowlab}/bin/windowlab";
        }];
    };
    environment.systemPackages = [ pkgs.windowlab ];
  };
}
