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
    package = lib.mkOption {
      default = pkgs.streamcontroller.override { isKde = config.services.desktopManager.plasma6.enable; };
      defaultText = lib.literalExpression "pkgs.streamcontroller";
      type = lib.types.package;
      description = ''
        The StreamController package to use
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ sifmelcara ];
}
