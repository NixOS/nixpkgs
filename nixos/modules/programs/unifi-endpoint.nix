{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.unifi-endpoint;
in
{
  options.programs.unifi-endpoint = {
    enable = lib.mkEnableOption "UniFi Endpoint, Ubiquiti's UniFi Identity VPN and WiFi client";

    package = lib.mkPackageOption pkgs "unifi-endpoint" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      # Invoked by the app and its privileged helper.
      pkgs.wireguard-tools
      pkgs.libsecret
      pkgs.libnotify
      pkgs.xdg-utils
      pkgs.glib
    ];

    # The executables, systemd units and polkit exec.path all hardcode
    # /usr/lib/UniFi-Endpoint, and the daemon rejects any client whose
    # /proc/<pid>/exe is not under it. A symlink would resolve to the store
    # path, so the package has to be bind-mounted there. This is a service
    # rather than a fileSystems entry because switch-to-configuration only
    # remounts changed mount units, which would keep the old package bound.
    systemd.services.unifi-endpoint-mount = {
      description = "Bind-mount UniFi Endpoint at /usr/lib/UniFi-Endpoint";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
      path = [ pkgs.util-linux ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        mkdir -p /usr/lib/UniFi-Endpoint
        if mountpoint -q /usr/lib/UniFi-Endpoint; then
          umount --lazy /usr/lib/UniFi-Endpoint
        fi
        mount --bind -o ro ${cfg.package}/lib/UniFi-Endpoint /usr/lib/UniFi-Endpoint
      '';
      preStop = ''
        umount --lazy /usr/lib/UniFi-Endpoint || true
      '';
    };

    # Socket-activated per-user daemon the GUI talks to.
    systemd.packages = [ cfg.package ];
    systemd.user.sockets.UniFi-Endpoint-Daemon.wantedBy = [ "sockets.target" ];

    # Upstream rules: let the active local session start the VPN helper
    # without a password prompt.
    security.polkit.enable = true;
    environment.etc."polkit-1/rules.d/50-unifi-endpoint.rules".source =
      "${cfg.package}/etc/polkit-1/rules.d/50-unifi-endpoint.rules";

    # The helper brings the tunnel up with wg-quick; keep NetworkManager off it.
    networking.networkmanager.unmanaged = [ "interface-name:ui-vpn" ];

    # Membership gates installing workspace CA certificates.
    users.groups.unifi-endpoint = { };
  };

  meta.maintainers = with lib.maintainers; [ kellanstevens ];
}
