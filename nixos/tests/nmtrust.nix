{ lib, pkgs, ... }:
{
  name = "nmtrust";

  nodes.machine =
    { pkgs, ... }:
    {
      networking.networkmanager.enable = true;

      # Prevent the VM's built-in interfaces from polluting trust state.
      networking.networkmanager.unmanaged = [
        "eth0"
        "eth1"
        "lo"
      ];

      networking.networkmanager.ensureProfiles.profiles = {
        trusted-net = {
          connection = {
            id = "trusted-net";
            uuid = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee";
            type = "dummy";
            interface-name = "dummy-trusted";
            autoconnect = "false";
          };
          ipv4.method = "manual";
          ipv4.addresses = "10.99.1.1/24";
        };
        untrusted-net = {
          connection = {
            id = "untrusted-net";
            uuid = "11111111-2222-3333-4444-555555555555";
            type = "dummy";
            interface-name = "dummy-untrusted";
            autoconnect = "false";
          };
          ipv4.method = "manual";
          ipv4.addresses = "10.99.2.1/24";
        };
      };

      services.nmtrust = {
        enable = true;
        trustedConnections = [ "trusted-net" ];
        systemUnits."trust-canary.service" = { };
      };

      # Canary service: runs only while the trusted target is active.
      systemd.services.trust-canary = {
        description = "nmtrust test canary";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.coreutils}/bin/sleep infinity";
        };
      };
    };

  testScript = ''
    import time

    def apply(machine):
        """Trigger nmtrust-apply and wait for it to finish."""
        time.sleep(1)
        machine.succeed("systemctl start nmtrust-apply.service")
        machine.wait_until_succeeds(
            "systemctl show nmtrust-apply.service -p ActiveState --value | grep -q inactive",
            timeout=10,
        )

    machine.wait_for_unit("multi-user.target")

    with subtest("offline on boot with no connections active"):
        apply(machine)
        machine.succeed("systemctl is-active nmtrust-offline.target")
        machine.fail("systemctl is-active trust-canary.service")

    with subtest("trusted when trusted connection is up"):
        machine.succeed("nmcli connection up trusted-net")
        apply(machine)
        machine.succeed("systemctl is-active nmtrust-trusted.target")
        machine.succeed("systemctl is-active trust-canary.service")

    with subtest("untrusted when untrusted connection replaces trusted"):
        machine.succeed("nmcli connection down trusted-net")
        machine.succeed("nmcli connection up untrusted-net")
        apply(machine)
        machine.succeed("systemctl is-active nmtrust-untrusted.target")
        machine.fail("systemctl is-active trust-canary.service")
  '';

  meta.maintainers = with lib.maintainers; [ brett ];
}
