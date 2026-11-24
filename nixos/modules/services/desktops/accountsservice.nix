# AccountsService daemon.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  meta = {
    teams = [ lib.teams.freedesktop ];
  };

  ###### interface
  options = {

    services.accounts-daemon = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable AccountsService, a DBus service for accessing
          the list of user accounts and information attached to those accounts.
        '';
      };

    };

  };

  ###### implementation
  config = lib.mkIf config.services.accounts-daemon.enable {

    environment.systemPackages = [ pkgs.accountsservice ];

    # Accounts daemon looks for dbus interfaces in $XDG_DATA_DIRS/accountsservice
    environment.pathsToLink = [ "/share/accountsservice" ];

    services.dbus.packages = [ pkgs.accountsservice ];

    systemd.packages = [ pkgs.accountsservice ];

    systemd.services.accounts-daemon =
      lib.recursiveUpdate
        {

          wantedBy = [ "graphical.target" ];

          # Accounts daemon looks for dbus interfaces in $XDG_DATA_DIRS/accountsservice
          environment.XDG_DATA_DIRS = "${config.system.path}/share";
          environment.LD_LIBRARY_PATH = config.system.nssModules.path;

        }
        (
          lib.optionalAttrs (!config.users.mutableUsers) {
            environment.NIXOS_USERS_PURE = "true";

            # The upstream unit grants write access to /etc and /home for the
            # shadow tools, and every method that runs them is disabled here.
            serviceConfig = {
              ReadWritePaths = [ "" ];
              ProtectHome = "read-only";
              # SetIconFile reads the icon as the calling user.
              CapabilityBoundingSet = [
                "CAP_SETUID"
                "CAP_SETGID"
              ];
              NoNewPrivileges = true;
              RestrictSUIDSGID = true;
              ProtectClock = true;
              ProtectHostname = true;
              ProtectKernelLogs = true;
              SystemCallFilter = [
                ""
                "@system-service"
                "~@privileged @resources"
                "@setuid"
              ];
              SystemCallErrorNumber = "EPERM";
            };
          }
        );
  };

}
