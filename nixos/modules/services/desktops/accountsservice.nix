# AccountsService daemon.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.accounts-daemon;

  package =
    if (cfg.useHomed || config.services.homed.enable) then
      pkgs.accountsservice
    else
      pkgs.accountsservice.override {
        useHomed = false;
      };
in
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

      useHomed = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to use systemd-homed as a backend for account metedata discovery.
        '';
      };
    };

  };

  ###### implementation
  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ package ];

    # Accounts daemon looks for dbus interfaces in $XDG_DATA_DIRS/accountsservice
    environment.pathsToLink = [ "/share/accountsservice" ];

    services.dbus.packages = [ package ];

    systemd.packages = [ package ];

    systemd.services.accounts-daemon =
      lib.recursiveUpdate
        {

          wantedBy = [ "graphical.target" ];

          # Accounts daemon looks for dbus interfaces in $XDG_DATA_DIRS/accountsservice
          environment.XDG_DATA_DIRS = "${config.system.path}/share";

        }
        (
          lib.optionalAttrs (!config.users.mutableUsers) {
            environment.NIXOS_USERS_PURE = "true";
          }
        );
  };

}
