{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.surfshark;
in
{
  options.services.surfshark = {
    enable = lib.mkEnableOption "Surfshark VPN client";
    package = lib.mkPackageOption pkgs "surfshark" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Install the systemd units shipped inside the package
    systemd.packages = [ cfg.package ];

    # surfsharkd2 — system daemon (manages VPN tunnels via openvpn/wireguard)
    systemd.services.surfsharkd2 = {
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        coreutils
        procps
        which
        iputils
      ];
    };

    # surfsharkd — per-user daemon (IPC bridge between GUI and system daemon)
    systemd.user.services.surfsharkd = {
      wantedBy = [ "default.target" ];
      environment = {
        # Required by the GJS daemon to import the NetworkManager typelib
        GI_TYPELIB_PATH = "${pkgs.networkmanager}/lib/girepository-1.0";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ FazalAAli ];
}
