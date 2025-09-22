{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.wshowkeys;
in
{
  options = {
    programs.wshowkeys = {
      enable = lib.mkEnableOption ''
        wshowkeys (displays keypresses on screen on supported Wayland
        compositors). It requires root permissions to read input events, but
        these permissions are dropped after startup'';
      package = lib.mkPackageOption pkgs "wshowkeys" { };
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.wshowkeys = {
      setuid = true;
      owner = "root";
      group = "root";
      source = lib.getExe cfg.package;
    };
  };

  meta.maintainers = with lib.maintainers; [ ];
}
