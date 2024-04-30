# rygel service.
{ config, lib, pkgs, ... }:

with lib;

{
  meta = {
    maintainers = teams.gnome.members;
  };

  ###### interface
  options = {
    services.gnome.rygel = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable Rygel UPnP Mediaserver.

          You will need to also allow UPnP connections in firewall, see the following [comment](https://github.com/NixOS/nixpkgs/pull/45045#issuecomment-416030795).
        '';
        type = types.bool;
      };
    };
  };

  ###### implementation
  config = mkIf config.services.gnome.rygel.enable {
    environment.systemPackages = [ pkgs.gnome.rygel ];

    services.dbus.packages = [ pkgs.gnome.rygel ];

    systemd.packages = [ pkgs.gnome.rygel ];

    environment.etc."rygel.conf".source = "${pkgs.gnome.rygel}/etc/rygel.conf";
  };
}
