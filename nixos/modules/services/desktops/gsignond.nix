# Accounts-SSO gSignOn daemon
{ config, lib, pkgs, ... }:
let
  package = pkgs.gsignond.override { plugins = config.services.gsignond.plugins; };
in
{

  meta.maintainers = [ ];

  ###### interface

  options = {

    services.gsignond = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable gSignOn daemon, a DBus service
          which performs user authentication on behalf of its clients.
        '';
      };

      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = ''
          What plugins to use with the gSignOn daemon.
        '';
      };
    };
  };

  ###### implementation
  config = lib.mkIf config.services.gsignond.enable {
    environment.etc."gsignond.conf".source = "${package}/etc/gsignond.conf";
    services.dbus.packages = [ package ];
  };

}
