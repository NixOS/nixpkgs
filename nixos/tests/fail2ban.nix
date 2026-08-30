{ pkgs, ... }:
{
  name = "fail2ban";

  nodes.machine = { ... }: {
    services.fail2ban = {
      enable = true;
      bantime-increment.enable = true;
    };
    services.openssh.enable = true;
    networking.nftables.enable = true;
  };

  nodes.client = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.sshpass
      pkgs.netcat
    ];

  };

  testScript = ''
    start_all()

    # Wait for everything to be ready.
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("fail2ban")
    machine.wait_for_unit("sshd")
    client.wait_for_unit("multi-user.target")

    client_addr = "2001:db8:1::1"
    machine_addr = "2001:db8:1::2"

    @polling_condition
    def fail2ban_running():
      machine.require_unit_state("fail2ban.service", "active")

    with fail2ban_running:
      with subtest("Verify reported versions"):
        clientVersion = machine.succeed("fail2ban-client -V").rstrip()
        t.assertEqual(clientVersion, "${pkgs.fail2ban.version}")
        serverVersion = machine.succeed("fail2ban-server -V").rstrip()
        t.assertEqual(serverVersion, "${pkgs.fail2ban.version}")

      with subtest("Verify that fail2ban-client can communicate with the server"):
        machine.succeed("fail2ban-client ping")
        # Verify that the socket is reachable via the fail2ban group
        machine.succeed("sudo -u nobody -g fail2ban fail2ban-client ping")

      with subtest("Verify there is not ban and the port is reachable from the client"):
        machine.succeed(f"test 0 -eq $(fail2ban-client get sshd banned {client_addr})")
        client.succeed(f"nc -w3 -z {machine_addr} 22")

      with subtest("Verify that banning works"):
        # Cause authentication failure log entries (detach second command since ban may cause timeout).
        client.fail(f"sshpass -p 'wrongpassword' ssh -o StrictHostKeyChecking=no {machine_addr}")
        client.execute(f"sshpass -p 'wrongpassword' ssh -o StrictHostKeyChecking=no {machine_addr} >&2 &")
        machine.wait_until_succeeds(f"test 1 -eq $(fail2ban-client get sshd banned {client_addr})")
        client.fail(f"nc -w3 -z {machine_addr} 22")

      with subtest("Verify that unbanning works"):
        machine.succeed(f"fail2ban-client unban {client_addr}")
        client.succeed(f"nc -w3 -z {machine_addr} 22")

      with subtest("Verify that fail2ban-regex works"):
        regex = r"^matching log entry: <HOST>$"
        line = "matching log entry: 1.2.3.4"
        matches = machine.succeed(f"fail2ban-regex -o matches '{line}' '{regex}'")
        t.assertIn(line, matches)

    with subtest("Verify that socket activation works"):
      machine.succeed("systemctl stop fail2ban.service")
      machine.require_unit_state("fail2ban.service", "inactive")
      machine.succeed("fail2ban-client ping")
      machine.require_unit_state("fail2ban.service", "active")
  '';
}
