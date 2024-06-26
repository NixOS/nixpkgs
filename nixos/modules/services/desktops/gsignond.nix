# Accounts-SSO gSignOn daemon

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  package = pkgs.gsignond.override { plugins = config.services.gsignond.plugins; };
in
{

  meta.maintainers = teams.pantheon.members;

  ###### interface

  options = {

    services.gsignond = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable gSignOn daemon, a DBus service
          which performs user authentication on behalf of its clients.
        '';
      };

      plugins = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = ''
          What plugins to use with the gSignOn daemon.
        '';
      };
    };
  };

  ###### implementation
  config = mkIf config.services.gsignond.enable {
    environment.etc."gsignond.conf".source = "${package}/etc/gsignond.conf";
    services.dbus.packages = [ package ];
  };

}
