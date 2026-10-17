{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.veyon;
in
{
  options = {
    services.veyon = {
      enable = lib.mkEnableOption "Veyon";
      package = lib.mkPackageOption pkgs "veyon" { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.dbus.enable = true;
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    systemd.services.veyon.wantedBy = [ "multi-user.target" ];

    security.wrappers = {
      "veyon-auth-helper" = {
        source = "${cfg.package}/bin/veyon-auth-helper";
        owner = "root";
        group = "root";
        setuid = true;
      };
      "veyon-input-helper" = {
        source = "${cfg.package}/bin/veyon-input-helper";
        owner = "root";
        group = "root";
        setuid = true;
      };
    };

  };

  meta.maintainers = pkgs.veyon.meta.maintainers;
}
