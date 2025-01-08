{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.nimdow;
in
{
  options = {
    services.xserver.windowManager.nimdow.enable = lib.mkEnableOption "nimdow";
    services.xserver.windowManager.nimdow.package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nimdow;
      defaultText = "pkgs.nimdow";
      description = "nimdow package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "nimdow";
      start = ''
        ${cfg.package}/bin/nimdow &
        waitPID=$!
      '';
    };
    environment.systemPackages = [
      cfg.package
      pkgs.st
    ];
  };
}
