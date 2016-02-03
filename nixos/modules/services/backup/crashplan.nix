{ config, pkgs, lib, ... }:

let
  cfg = config.services.crashplan;
  crashplan = pkgs.crashplan;
  varDir = "/var/lib/crashplan";
  user = "crashplan";
in

with lib;

{
  options = {
    services.crashplan = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Starts crashplan background service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ crashplan ];

    users.users.${user} = {
      description = "CrashPlan Backup Engine";
      isSystemUser = true;
      home = varDir;
      createHome = true;
    };

    systemd.services.crashplan = {
      description = "CrashPlan Backup Engine";

      wantedBy = [ "multi-user.target" ];
      after    = [ "network.target" ];

      serviceConfig = {
        Type = "idle";
        User = user;
        ExecStart = "${crashplan}/bin/crashplan";
        WorkingDirectory = crashplan;
      };
    };
  };
}
