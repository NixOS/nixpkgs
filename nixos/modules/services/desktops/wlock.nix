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
    services.wlock = {
      enable = lib.mkEnableOption "wlock, a Wayland sessionlocker using the ext-session-lock-v1 protocol";

      package = lib.mkPackageOption pkgs "wlock" { };
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.wlock = {
      owner = "root";
      group = "root";
      # mirror upstream chmod of 4755
      setuid = true;
      setgid = false;
      source = lib.getExe cfg.package;
    };
  };

  meta.maintainers = [ lib.maintainers.fliegendewurst ];
}
