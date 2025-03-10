{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.kclock;
  kclockPkg = pkgs.libsForQt5.kclock;
in
{
  options.programs.kclock = {
    enable = lib.mkEnableOption "KClock";
  };

  config = lib.mkIf cfg.enable {
    services.dbus.packages = [ kclockPkg ];
    environment.systemPackages = [ kclockPkg ];
  };
}
