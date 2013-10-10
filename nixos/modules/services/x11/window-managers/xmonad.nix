{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.windowManager.xmonad;
in

{
  options = {
    services.xserver.windowManager.xmonad = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the xmonad window manager.";
      };
    };
  };

  config = {
    services.xserver.windowManager = {
      session = mkIf cfg.enable [{
        name = "xmonad";
        start = "
          ${pkgs.haskellPackages.xmonad}/bin/xmonad &
          waitPID=$!
        ";
      }];
    };
  };
}
