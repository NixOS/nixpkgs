{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.streamcontroller;
in
{
  options.programs.streamcontroller = {
    enable = lib.mkEnableOption "StreamController";
    package = lib.mkPackageOption pkgs "streamcontroller" { default = [ "streamcontroller" ]; };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ sifmelcara ];
}
