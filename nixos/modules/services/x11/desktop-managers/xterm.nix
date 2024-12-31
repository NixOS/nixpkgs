{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.xserver.desktopManager.xterm;
  xSessionEnabled = config.services.xserver.enable;

in

{
  options = {

    services.xserver.desktopManager.xterm.enable = lib.mkOption {
      type = lib.types.bool;
      default = lib.versionOlder config.system.stateVersion "19.09" && xSessionEnabled;
      defaultText = lib.literalExpression ''versionOlder config.system.stateVersion "19.09" && config.services.xserver.enable;'';
      description = "Enable a xterm terminal as a desktop manager.";
    };

  };

  config = lib.mkIf cfg.enable {

    services.xserver.desktopManager.session = lib.singleton {
      name = "xterm";
      start = ''
        ${pkgs.xterm}/bin/xterm -ls &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ pkgs.xterm ];

  };

}
