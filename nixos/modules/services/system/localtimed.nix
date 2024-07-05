{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.localtimed;
in {
  imports = [ (lib.mkRenamedOptionModule [ "services" "localtime" ] [ "services" "localtimed" ]) ];

  options = {
    services.localtimed = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable `localtimed`, a simple daemon for keeping the
          system timezone up-to-date based on the current location. It uses
          geoclue2 to determine the current location.
        '';
      };
      package = mkPackageOption pkgs "localtime" { };
      geoclue2Package = mkPackageOption pkgs "geoclue2-with-demo-agent" { };
    };
  };

  config = mkIf cfg.enable {
    services.geoclue2.appConfig.localtimed = {
      isAllowed = true;
      isSystem = true;
      users = [ (toString config.ids.uids.localtimed) ];
    };

    # Install the polkit rules.
    environment.systemPackages = [ cfg.package ];

    systemd.services.localtimed = {
      wantedBy = [ "multi-user.target" ];
      partOf = [ "localtimed-geoclue-agent.service" ];
      after = [ "localtimed-geoclue-agent.service" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/localtimed";
        Restart = "on-failure";
        Type = "exec";
        User = "localtimed";
      };
    };

    systemd.services.localtimed-geoclue-agent = {
      wantedBy = [ "multi-user.target" ];
      partOf = [ "geoclue.service" ];
      after = [ "geoclue.service" ];
      serviceConfig = {
        ExecStart = "${cfg.geoclue2Package}/libexec/geoclue-2.0/demos/agent";
        Restart = "on-failure";
        Type = "exec";
        User = "localtimed";
      };
    };

    users = {
      users.localtimed = {
        uid = config.ids.uids.localtimed;
        group = "localtimed";
      };
      groups.localtimed.gid = config.ids.gids.localtimed;
    };
  };
}
