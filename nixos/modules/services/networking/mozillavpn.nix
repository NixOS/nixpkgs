{ config, lib, pkgs, ... }:

{
  options.services.mozillavpn.enable =
    lib.mkEnableOption (lib.mdDoc "Mozilla VPN daemon");

  config = lib.mkIf config.services.mozillavpn.enable {
    environment.systemPackages = [ pkgs.mozillavpn ];
    services.dbus.packages = [ pkgs.mozillavpn ];
    systemd.packages = [ pkgs.mozillavpn ];
  };

  meta.maintainers = with lib.maintainers; [ andersk ];
}
