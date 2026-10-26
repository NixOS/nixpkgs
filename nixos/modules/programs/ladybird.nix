{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.ladybird;
in
{
  options = {
    programs.ladybird.enable = lib.mkEnableOption "the Ladybird web browser";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ladybird ];
    services.dbus.packages = [ pkgs.ladybird ];
    fonts.fontDir.enable = true;
  };
}
