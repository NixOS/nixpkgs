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
    enable = lib.mkEnableOption "all of the xscreensaver programs";
    package = lib.mkPackageOption pkgs "xscreensaver" { };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    programs.xscreensaver.sonar.enable = true;
  };
}
