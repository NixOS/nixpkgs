{ pkgs, ... }:

let
  client =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.upterm ];
    };
in
{
  name = "uptermd";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ fleaz ];
  };

  nodes = {
    server =
      { config, ... }:
      {
        services.uptermd = {
          enable = true;
          openFirewall = true;
          port = 1337;
        };
      };
    client1 = client;
    client2 = client;
  };

  testScript = ''
    start_all()

    server.wait_for_unit("uptermd.service")
    server.systemctl("start network-online.target")
    server.wait_for_unit("network-online.target")

    # wait for upterm port to be reachable
    client1.wait_until_succeeds("nc -z -v server 1337")

    # Add SSH hostkeys from the server to both clients
    # uptermd needs an '@cert-authority entry so we need to modify the known_hosts file
    client1.execute("mkdir -p ~/.ssh && ssh -o StrictHostKeyChecking=no -p 1337 server ls")
    client1.execute("echo @cert-authority $(cat ~/.ssh/known_hosts) > ~/.ssh/known_hosts")
    client2.execute("mkdir -p ~/.ssh && ssh -o StrictHostKeyChecking=no -p 1337 server ls")
    client2.execute("echo @cert-authority $(cat ~/.ssh/known_hosts) > ~/.ssh/known_hosts")

    client1.wait_for_unit("multi-user.target")
    client1.wait_until_succeeds("pgrep -f 'agetty.*tty1'")
    client1.wait_until_tty_matches("1", "login: ")
    client1.send_chars("root\n")
    client1.wait_until_succeeds("pgrep -u root bash")

    client1.execute("ssh-keygen -t ed25519 -N \"\" -f /root/.ssh/id_ed25519")
    client1.send_chars("TERM=xterm upterm host --server ssh://server:1337 --force-command hostname -- bash > /tmp/session-details\n")
    client1.wait_for_file("/tmp/session-details")
    client1.send_key("q")

    # uptermd can't connect if we don't have a keypair
    client2.execute("ssh-keygen -t ed25519 -N \"\" -f /root/.ssh/id_ed25519")

    # Grep the ssh connect command from the output of 'upterm host'
    ssh_command = client1.succeed("grep 'SSH Session' /tmp/session-details | cut -d':' -f2-").strip()

    # Connect with client2. Because we used '--force-command hostname' we should get "client1" as the output
    output = client2.succeed(ssh_command)

    assert output.strip() == "client1"
  '';
}
