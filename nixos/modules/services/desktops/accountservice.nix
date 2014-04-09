# AccountsService daemon.

{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    services.accounts-daemon = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable AccountsService, a DBus service for accessing
          the list of user accounts and information attached to those accounts.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.accounts-daemon.enable {

    environment.systemPackages = [ pkgs.accountservice ];

    services.dbus.packages = [ pkgs.accountservice ];

    systemd.packages = [ pkgs.accountservice ];
  };

}
