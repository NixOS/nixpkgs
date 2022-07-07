{ config, lib, pkgs, ... }:

{
  options.services.mozillavpn.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Enable the Mozilla VPN daemon.
    '';
  };

  config = lib.mkIf config.services.mozillavpn.enable {
    environment.systemPackages = [ pkgs.mozillavpn ];
    services.dbus.packages = [ pkgs.mozillavpn ];
    systemd.packages = [ pkgs.mozillavpn ];
  };

  meta.maintainers = with lib.maintainers; [ andersk ];
}
