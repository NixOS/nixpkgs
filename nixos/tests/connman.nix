{ pkgs, lib, ... }:
{
  name = "connman";
  meta = with lib.maintainers; {
    maintainers = [ rnhmjoj ];
  };

  # Router running radvd on VLAN 1
  nodes.router =
    { ... }:
    {
      imports = [ ../modules/profiles/minimal.nix ];

      virtualisation.vlans = [ 1 ];

      boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;

      networking = {
        useDHCP = false;
        interfaces.eth1.ipv6.addresses = [
          {
            address = "fd12::1";
            prefixLength = 64;
          }
        ];
      };

      services.radvd = {
        enable = true;
        config = ''
          interface eth1 {
            AdvSendAdvert on;
            AdvManagedFlag on;
            AdvOtherConfigFlag on;
            prefix fd12::/64 {
              AdvAutonomous off;
            };
          };
        '';
      };
    };

  # Client running connman, connected to VLAN 1
  nodes.client =
    { ... }:
    {
      virtualisation.vlans = [ 1 ];

      # add a virtual wlan interface
      boot.kernelModules = [ "mac80211_hwsim" ];
      boot.extraModprobeConfig = ''
        options mac80211_hwsim radios=1
      '';

      # Note: the overrides are needed because the wifi is
      # disabled with mkVMOverride in qemu-vm.nix.
      services.connman.enable = lib.mkOverride 0 true;
      services.connman.networkInterfaceBlacklist = [ "eth0" ];
      networking.wireless.enable = lib.mkOverride 0 true;
      networking.wireless.interfaces = [ "wlan0" ];
    };

  testScript = ''
    start_all()

    with subtest("Router is ready"):
        router.wait_for_unit("radvd.service")

    with subtest("Daemons are running"):
        client.wait_for_unit("wpa_supplicant-wlan0.service")
        client.wait_for_unit("connman.service")
        client.wait_until_succeeds("connmanctl state | grep -q ready")

    with subtest("Wired interface is configured"):
        client.wait_until_succeeds("ip -6 route | grep -q fd12::/64")
        client.wait_until_succeeds("ping -c 1 fd12::1")

    with subtest("Can set up a wireless access point"):
        client.succeed("connmanctl enable wifi")
        client.wait_until_succeeds("connmanctl tether wifi on nixos-test reproducibility | grep -q 'Enabled'")
        client.wait_until_succeeds("iw wlan0 info | grep -q nixos-test")
  '';
}
