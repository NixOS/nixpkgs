{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.localtimed;
in
{
  imports = [ (lib.mkRenamedOptionModule [ "services" "localtime" ] [ "services" "localtimed" ]) ];

  options = {
    services.localtimed = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable `localtimed`, a simple daemon for keeping the
          system timezone up-to-date based on the current location. It uses
          geoclue2 to determine the current location.

          To avoid silent overriding by the service, if you have explicitly set a
          timezone, either remove it or ensure that it is set with a lower priority
          than the default value using `lib.mkDefault` or `lib.mkOverride`. This is
          to make the choice deliberate. An error will be presented otherwise.
        '';
      };
      package = lib.mkPackageOption pkgs "localtime" { };
      geoclue2Package = lib.mkPackageOption pkgs "Geoclue2" { default = "geoclue2-with-demo-agent"; };
    };
  };

  config = lib.mkIf cfg.enable {
    # This will give users an error if they have set an explicit time
    # zone, rather than having the service silently override it.
    time.timeZone = null;

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
