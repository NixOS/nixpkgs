{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ly-lock;
in
{
  options.programs.ly-lock = {
    enable = lib.mkEnableOption "ly-lock, a Wayland lock screen that looks like the ly display manager";
    package = lib.mkPackageOption pkgs "ly-lock" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # ly-lock authenticates through its own PAM service.
    security.pam.services.ly-lock = { };
  };

  meta.maintainers = with lib.maintainers; [ rugbedbugg ];
}
