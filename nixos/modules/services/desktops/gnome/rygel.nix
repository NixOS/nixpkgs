# rygel service.
{
  config,
  lib,
  pkgs,
  ...
}:

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
    };
  };

  ###### implementation
  config = lib.mkIf config.services.gnome.rygel.enable {
    environment.systemPackages = [ pkgs.rygel ];

    services.dbus.packages = [ pkgs.rygel ];

    systemd.packages = [ pkgs.rygel ];

    environment.etc."rygel.conf".source = "${pkgs.rygel}/etc/rygel.conf";
  };
}
