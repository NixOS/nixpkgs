{ pkgs, lib, ... }: with lib; {
  boot.isContainer = true;

  # We need a static libsudoers if we bind-mount into a user-namespaced
  # container since the bind-mounts are owned by `nouser:nogroup` then (including
  # `/nix/store`) and this doesn't like sudo.
  security.sudo.package = mkDefault pkgs.sudo-nspawn;

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
    dhcpConfig.UseTimezone = "yes";
    networkConfig = {
      DHCP = lib.mkDefault "yes";
      LLDP = "yes";
      EmitLLDP = "customer-bridge";
      LinkLocalAddressing = mkDefault "ipv6";
    };
  };
}
