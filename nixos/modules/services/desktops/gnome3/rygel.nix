# rygel service.
{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface
  options = {
    services.gnome3.rygel = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable Rygel UPnP Mediaserver.

          You will need to also allow UPnP connections in firewall, see the following <link xlink:href="https://github.com/NixOS/nixpkgs/pull/45045#issuecomment-416030795">comment</link>.
        '';
        type = types.bool;
      };
    };
  };

  ###### implementation
  config = mkIf config.services.gnome3.rygel.enable {
    environment.systemPackages = [ pkgs.gnome3.rygel ];

    services.dbus.packages = [ pkgs.gnome3.rygel ];

    systemd.packages = [ pkgs.gnome3.rygel ];
  };
}
