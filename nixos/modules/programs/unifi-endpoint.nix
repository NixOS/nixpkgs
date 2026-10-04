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
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable UniFi Endpoint, Ubiquiti's UniFi Identity VPN and WiFi client.

        Only members of the `unifi-endpoint` group can install workspace CA
        certificates from the app:

        ```nix
        users.users.alice.extraGroups = [ "unifi-endpoint" ];
        ```
      '';
    };

    package = lib.mkPackageOption pkgs "unifi-endpoint" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      # The closed-source binaries run these by name. The privileged helper
      # runs as root under pkexec, which resets PATH to /usr/sbin:/usr/bin:/sbin:/bin,
      # so the tools have to be in the system profile rather than a wrapper's PATH.
      pkgs.wireguard-tools # wg-quick
      (lib.getBin pkgs.libsecret) # secret-tool
      (lib.getBin pkgs.libnotify) # notify-send
      (lib.getBin pkgs.xdg-utils) # xdg-open
      (lib.getBin pkgs.glib) # gio, for mounting UniFi Drive shares
    ];

    # The executables, systemd units and polkit exec.path all hardcode
    # /usr/lib/UniFi-Endpoint, and the daemon rejects any client whose
    # /proc/<pid>/exe is not under it. A symlink would resolve to the store
    # path, so the package has to be bind-mounted there. LazyUnmount lets
    # switch-to-configuration swap in a new package while the app is running;
    # a plain unmount fails with "target is busy".
    systemd.mounts = [
      {
        description = "UniFi Endpoint at /usr/lib/UniFi-Endpoint";
        what = "${cfg.package}/lib/UniFi-Endpoint";
        where = "/usr/lib/UniFi-Endpoint";
        type = "none";
        options = "bind,ro";
        wantedBy = [ "multi-user.target" ];
        mountConfig.LazyUnmount = true;
      }
    ];

    # The package ships a socket-activated user daemon that the GUI talks to.
    # NixOS ignores [Install] sections in packaged units, so enable the socket
    # here; this matches `systemctl --global enable` in upstream's postinst.
    systemd.packages = [ cfg.package ];
    systemd.user.sockets.UniFi-Endpoint-Daemon.wantedBy = [ "sockets.target" ];

    # The daemon runs the privileged helper through pkexec. Upstream's rules
    # let the active local session do so without a password prompt.
    security.polkit.enable = true;
    security.polkit.enablePkexecWrapper = true;
    environment.etc."polkit-1/rules.d/50-unifi-endpoint.rules".source =
      "${cfg.package}/etc/polkit-1/rules.d/50-unifi-endpoint.rules";

    # Upstream ships this so NetworkManager ignores the wg-quick tunnel.
    networking.networkmanager.unmanaged = [ "interface-name:ui-vpn" ];

    # Only people in this group can install workspace CA certificates.
    users.groups.unifi-endpoint = { };
  };

  meta.maintainers = with lib.maintainers; [ kellanstevens ];
}
