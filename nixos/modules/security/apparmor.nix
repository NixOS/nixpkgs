{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.apparmor;
in
{
  options = {
    security.apparmor = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the AppArmor Mandatory Access Control system.";
      };

      profiles = mkOption {
        type = types.listOf types.path;
        default = [];
        description = "List of files containing AppArmor profiles.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.apparmor ];
    systemd.services.apparmor = {
      wantedBy = [ "local-fs.target" ];
      path     = [ pkgs.apparmor ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = concatMapStrings (profile:
          ''${pkgs.apparmor}/sbin/apparmor_parser -rKv -I ${pkgs.apparmor}/etc/apparmor.d/ "${profile}" ; ''
        ) cfg.profiles;
        ExecStop = concatMapStrings (profile:
          ''${pkgs.apparmor}/sbin/apparmor_parser -Rv -I ${pkgs.apparmor}/etc/apparmor.d/ "${profile}" ; ''
        ) cfg.profiles;
      };
    };
  };
}
