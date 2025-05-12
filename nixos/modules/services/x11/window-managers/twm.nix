{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.xserver.windowManager.twm;
in
{
  ###### interface
  options.services.xserver.windowManager.twm = {
    enable = lib.mkEnableOption "twm";
    package = lib.mkPackageOption pkgs [ "xorg" "twm" ] { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "twm";
      start = ''
        ${cfg.package}/bin/twm &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ cfg.package ];
  };
}
