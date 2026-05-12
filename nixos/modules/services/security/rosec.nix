{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.rosec;
in
{
  options.services.rosec = {
    enable = lib.mkEnableOption "rosec, a secrets daemon implementing the freedesktop.org Secret Service API";

    package = lib.mkPackageOption pkgs "rosec" { };

    pam = {
      enable = lib.mkEnableOption "PAM integration to automatically unlock the rosec vault on login";

      services = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ "login" ];
        description = ''
          List of PAM services for which to enable rosec automatic unlock.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    xdg.portal.extraPortals = [ cfg.package ];

    security.pam.services = lib.mkIf cfg.pam.enable (
      lib.genAttrs cfg.pam.services (_: {
        rosec.enable = true;
      })
    );
  };

  meta.maintainers = with lib.maintainers; [ mikilio ];
}
