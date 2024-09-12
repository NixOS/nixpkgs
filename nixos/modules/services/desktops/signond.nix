{ config, lib, pkgs, ... }:
let
  package = config.services.signond.package.override { plugins = config.services.signond.plugins; };
in
{
  options = {
    services.signond = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable signond, a DBus service
          which performs user authentication on behalf of its clients.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        description = ''
          Which signond package to use.
          Should get set by your desktop environment.
        '';
      };

      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = ''
          What plugins to use with the signon daemon.
        '';
      };
    };
  };

  config = lib.mkIf config.services.signond.enable {
    services.dbus.packages = [ package ];
    environment.systemPackages = [ (pkgs.hiPrio package) ];
  };
}
