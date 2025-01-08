{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkPackageOption
    singleton
    ;
  cfg = config.services.xserver.windowManager.katriawm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.katriawm = {
      enable = lib.mkEnableOption "katriawm";
      package = lib.mkPackageOption pkgs "katriawm" { };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "katriawm";
      start = ''
        ${cfg.package}/bin/katriawm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
