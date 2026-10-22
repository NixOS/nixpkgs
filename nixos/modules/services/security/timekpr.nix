{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.timekpr;
  targetBaseDir = "/var/lib/timekpr";
  daemonUser = "root";
  daemonGroup = "root";
in
{
  options = {
    services.timekpr = {
      package = lib.mkPackageOption pkgs "timekpr" { };
      enable = lib.mkEnableOption "Timekpr-nExT, a screen time managing application that helps optimizing time spent at computer for your subordinates, children or even for yourself";
      adminUsers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "alice"
          "bob"
        ];
        description = ''
          All listed users will become part of the `timekpr` group so they can manage timekpr settings without requiring sudo.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.timekpr = {
      gid = 2000;
      members = cfg.adminUsers;
    };

    environment.systemPackages = [
      # Add timekpr to system packages so that polkit can find it
      cfg.package
    ];
    services.dbus.enable = true;
    services.dbus.packages = [
      cfg.package
    ];
    environment.etc."timekpr" = {
      source = "${cfg.package}/etc/timekpr";
    };
    systemd.packages = [
      cfg.package
    ];
    systemd.services.timekpr = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
    };
    security.polkit.enable = true;
    systemd.tmpfiles.rules = [
      "d ${targetBaseDir} 0755 ${daemonUser} ${daemonGroup} -"
      "d ${targetBaseDir}/config 0755 ${daemonUser} ${daemonGroup} -"
      "d ${targetBaseDir}/work 0755 ${daemonUser} ${daemonGroup} -"
    ];
  };

  meta.maintainers = [ lib.maintainers.atry ];
}
