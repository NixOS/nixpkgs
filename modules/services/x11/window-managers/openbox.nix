{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf;
  cfg = config.services.xserver.windowManager.openbox;
in

{
  options = {
    services.xserver.windowManager.openbox = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the Openbox window manager.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [{
        name = "openbox";
        start = "
          ${pkgs.openbox}/bin/openbox-session
        ";
      }];
    };
    environment.x11Packages = [ pkgs.openbox ];
  };
}
