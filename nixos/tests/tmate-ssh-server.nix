import ./make-test-python.nix ({ pkgs, lib, ... }:
{
  name = "tmate-ssh-server";
  nodes =
    {
      server = { ... }: {
        services.tmate-ssh-server = {
          enable = true;
          port = 2223;
        };
      };
      client = { ... }: {
        environment.systemPackages = [ pkgs.tmate ];
      };
      client2 = { ... }: {
        environment.systemPackages = [ pkgs.tmate pkgs.openssh ];
      };
    };
  testScript = ''
    start_all()

    server.wait_for_unit("tmate-ssh-server.service")
    server.wait_for_open_port(2223)
    server.wait_for_file("/etc/tmate-ssh-server-keys/ssh_host_ed25519_key.pub")
    server.wait_for_file("/etc/tmate-ssh-server-keys/ssh_host_rsa_key.pub")
    server.succeed("tmate-client-config > /tmp/tmate.conf")
    server.wait_for_file("/tmp/tmate.conf")
    server.copy_from_vm("/tmp/tmate.conf")

    client.copy_from_host("tmate.conf", "/tmp/tmate.conf")
    client.wait_for_file("/tmp/tmate.conf")
    client.send_chars("root\n")
    client.sleep(2)
    client.send_chars("tmate -f /tmp/tmate.conf\n")
    client.sleep(2)
    client.send_chars("q")
    client.sleep(2)
    client.send_chars("tmate display -p '#{tmate_ssh}' > /tmp/ssh_command\n")
    client.wait_for_file("/tmp/ssh_command")
    ssh_cmd = client.succeed("cat /tmp/ssh_command")

    client2.succeed("mkdir -p ~/.ssh; ssh-keyscan -p 2223 server > ~/.ssh/known_hosts")
    client2.send_chars("root\n")
    client2.sleep(2)
    client2.send_chars(ssh_cmd.strip() + "\n")
    client2.sleep(2)
    client2.send_chars("touch /tmp/client_2\n")

    client.wait_for_file("/tmp/client_2")
  '';
})
