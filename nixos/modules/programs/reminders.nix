{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.reminders;
in
{
  options.programs.reminders = {
    enable = lib.mkEnableOption "Reminders, an open source reminder app";
    package = lib.mkPackageOption pkgs "reminders" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ pluiedev ];
}
