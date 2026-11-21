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
    package = lib.mkPackageOption pkgs "tab-window-manager" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "twm";
      start = ''
        ${lib.getExe cfg.package} &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ cfg.package ];
  };
}
