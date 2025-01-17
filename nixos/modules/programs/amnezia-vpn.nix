{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.amnezia-vpn;
in
{
  options.programs.amnezia-vpn = {
    enable = lib.mkEnableOption "The AmneziaVPN client";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.amnezia-vpn ];
    services.dbus.packages = [ pkgs.amnezia-vpn ];
    services.resolved.enable = true;

    systemd = {
      packages = [ pkgs.amnezia-vpn ];
      services."AmneziaVPN".wantedBy = [ "multi-user.target" ];
    };
  };

  meta.maintainers = with lib.maintainers; [ sund3RRR ];
}
