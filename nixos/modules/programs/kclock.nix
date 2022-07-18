{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.programs.kclock;
  kclockPkg = pkgs.libsForQt5.kclock;
in {
  options.programs.kclock = { enable = mkEnableOption "Enable KClock"; };

  config = mkIf cfg.enable {
    services.dbus.packages = [ kclockPkg ];
    environment.systemPackages = [ kclockPkg ];
  };
}
