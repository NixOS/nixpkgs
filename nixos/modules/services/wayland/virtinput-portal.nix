{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.virtinput-portal;
in
{
  options.services.virtinput-portal = {
    enable = lib.mkEnableOption "virtinput-portal";
    package = lib.mkPackageOption pkgs "virtinput-portal" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
  };
}
