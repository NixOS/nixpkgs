# rygel service.
{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.gnome.rygel;

in

{
  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface
  options = {
    services.gnome.rygel = {
      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to enable Rygel UPnP Mediaserver.

          You will need to also allow UPnP connections in firewall, see the following [comment](https://github.com/NixOS/nixpkgs/pull/45045#issuecomment-416030795).
        '';
        type = lib.types.bool;
      };

      package = lib.options.mkPackageOption pkgs "rygel" { };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    environment.etc."rygel.conf".source = "${cfg.package}/etc/rygel.conf";
  };
}
