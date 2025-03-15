{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.wlock;
in
{
  options = {
    services.wlock.enable = lib.mkEnableOption "wlock, a Wayland sessionlocker using the ext-session-lock-v1 protocol";
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.wlock = {
      owner = "root";
      setuid = true;
      source = lib.getExe pkgs.wlock;
    };
  };

  meta.maintainers = [ lib.maintainers.fliegendewurst ];
}
