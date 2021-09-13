{ pkgs, lib, ... }: with lib; {
  config = {
    boot.isContainer = true;

    # We need a static libsudoers if we bind-mount into a user-namespaced
    # container since the bind-mounts are owned by `nouser:nogroup` then (including
    # `/nix/store`) and this doesn't like sudo.
    security.sudo.package = mkDefault pkgs.sudo-nspawn;

    # FIXME get rid of this hack!
    # On a test-system I experienced that this service was hanging for no reason.
    # After a config-activation in ExecReload which affected larger parts of the OS in the
    # container, `nixops` waited until the timeout was reached. However, the networkd
    # was routable and the `host0` interface reached the state `configured`. Hence I'd guess
    # that this is a networkd bug that requires investigation. Until then, I'll leave
    # this as-is.
    systemd.services.systemd-networkd-wait-online.serviceConfig.ExecStart = mkForce [
      ""
      "/run/current-system/sw/bin/true"
    ];

    # Containers are supposed to use systemd-networkd to have a proper
    # networking stack even during boot-up.
    networking = {
      useHostResolvConf = false;
      useDHCP = false;
      useNetworkd = true;
    };
    systemd.network.networks."20-host0" = {
      matchConfig = {
        Virtualization = "container";
        Name = "host0";
      };
      linkConfig.RequiredForOnline = "no";
      dhcpConfig.UseTimezone = "yes";
      networkConfig = {
        DHCP = "yes";
        LLDP = "yes";
        EmitLLDP = "customer-bridge";
        LinkLocalAddressing = mkDefault "ipv6";
      };
    };
  };
}
