# AccountsService daemon.
{ config, lib, pkgs, ... }:
{
  meta = {
    maintainers = lib.teams.freedesktop.members;
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

    systemd.services.accounts-daemon = lib.recursiveUpdate {

      wantedBy = [ "graphical.target" ];

      # Accounts daemon looks for dbus interfaces in $XDG_DATA_DIRS/accountsservice
      environment.XDG_DATA_DIRS = "${config.system.path}/share";

    } (lib.optionalAttrs (!config.users.mutableUsers) {
      environment.NIXOS_USERS_PURE = "true";
    });
  };

}
