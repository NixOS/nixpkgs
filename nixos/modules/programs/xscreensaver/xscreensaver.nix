{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.xscreensaver;
in
{
  options.programs.xscreensaver = {
    package = lib.mkPackageOption pkgs "xscreensaver" { };
    enable = lib.mkEnableOption "all of the xscreensaver programs";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    programs.xscreensaver.sonar.enable = true;
  };
}
