{ lib, ... }:
{
  name = "systemd-networkd-override-strategy";

  meta = {
    maintainers = [ ];
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      networking = {
        useNetworkd = true;
        useDHCP = false;
      };

      systemd.network = {
        enable = true;
        networks = {
          # A regular unit without overrideStrategy should be a standalone file.
          "50-regular" = {
            matchConfig.Name = "eth0";
            networkConfig.DHCP = "yes";
          };

          # A unit with overrideStrategy = "asDropin" should always be a drop-in.
          "80-container-host0" = {
            overrideStrategy = "asDropin";
            matchConfig.Name = "host0";
            networkConfig.DHCP = "yes";
          };
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("systemd-networkd.service")

    # Regular unit should be a standalone file.
    machine.succeed("test -f /etc/systemd/network/50-regular.network")
    machine.fail("test -d /etc/systemd/network/50-regular.network.d")

    # Unit with overrideStrategy = "asDropin" should be a drop-in.
    machine.succeed("test -f /etc/systemd/network/80-container-host0.network.d/overrides.conf")
    machine.fail("test -f /etc/systemd/network/80-container-host0.network")
  '';
}
