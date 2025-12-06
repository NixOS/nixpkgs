{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.xserver.desktopManager.xterm;
  xSessionEnabled = config.services.xserver.enable;
  inherit (lib)
    mkOption
    types
    mkIf
    singleton
    literalExpression
    ;
in
{
  options = {
    services.xserver.desktopManager.xterm.enable = mkOption {
      type = types.bool;
      default = xSessionEnabled;
      defaultText = literalExpression ''config.services.xserver.enable'';
      description = "Enable a xterm terminal as a desktop manager.";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.session = singleton {
      name = "xterm";
      start = ''
        ${pkgs.xterm}/bin/xterm -ls &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.xterm ];
  };
}
