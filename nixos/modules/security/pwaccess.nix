{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.security.pwaccess;
in
{
  options.security.pwaccess.enable = lib.mkEnableOption "pwaccess";
  options.security.pwaccess.package = lib.mkPackageOption pkgs "pwaccess" { };

  config = lib.mkIf cfg.enable {
    # use pwaccess reimplementation of pam_unix
    security.pam.pam_unixModulePath = "${cfg.package}/lib/security/pam_unix_ng.so";

    systemd.packages = [ cfg.package ];

    systemd.sockets.pwaccessd.wantedBy = [ "sockets.target" ];
    systemd.sockets.pwupdd.wantedBy = [ "sockets.target" ];

    # use pwacces passwd
    environment.systemPackages = [ cfg.package ];

    security.pam.services.pwupd-passwd = { };

    security.loginDefs.package = pkgs.shadow.override { withPwaccess = true; };
  };
}
