{ pkgs, ... }:
{
  name = "fail2ban";

  nodes.machine = _: {
    services.fail2ban = {
      enable = true;
      bantime-increment.enable = true;
    };
    services.openssh.enable = true;
    networking.nftables.enable = true;
  };

  nodes.client = _: {
    environment.systemPackages = [
      pkgs.sshpass
      pkgs.libressl.nc
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

    # Verify there is not ban and the port is reachable from the client.
    machine.succeed(f"test 0 -eq $(fail2ban-client get sshd banned {client_addr})")
    client.succeed(f"nc -w3 -z {machine_addr} 22")

    # Cause authentication failure log entries.
    for _ in range(2):
      client.fail(f"sshpass -p 'wrongpassword' ssh -o StrictHostKeyChecking=no {machine_addr}")

    # Verify there is a ban and the port is unreachable from the client.
    machine.wait_until_succeeds(f"test 1 -eq $(fail2ban-client get sshd banned {client_addr})")
    client.fail(f"nc -w3 -z {machine_addr} 22")
  '';
}
