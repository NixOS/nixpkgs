{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.ratpoison;
in
{
  ###### interface
  options.services.xserver.windowManager.ratpoison = {
    enable = lib.mkEnableOption "ratpoison";
    package = lib.mkPackageOption pkgs "ratpoison" { };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "ratpoison";
      start = ''
        ${cfg.package}/bin/ratpoison &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ cfg.package ];
  };
}
