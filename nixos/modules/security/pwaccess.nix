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
  options.security.pwaccess.enable = lib.mkEnableOption "Use account-utils pwaccess sockets for user editing and pam";
  options.security.pwaccess.package = lib.mkPackageOption pkgs "account-utils" { };

  config = lib.mkIf cfg.enable {
    # use account-utils reimplementation of pam_unix
    security.pam.pam_unixModulePath = "${cfg.package}/lib/security/pam_unix_ng.so";

    systemd.packages = [ cfg.package ];
    systemd.sockets.pwaccessd.wantedBy = [ "sockets.target" ];
    systemd.sockets.pwupdd.wantedBy = [ "sockets.target" ];
    systemd.sockets.newidmapd.wantedBy = [ "sockets.target" ];

    environment.systemPackages = [ cfg.package ];

    security.pam.services.pwupd-passwd = { };

    # covered by account-utils via pwaccess socket-activated service
    security.wrappers = {
      newuidmap.enable = false;
      newgidmap.enable = false;
      chsh.enable = false;
      passwd.enable = false;
    };
  };
}
