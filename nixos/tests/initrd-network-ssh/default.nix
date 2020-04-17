import ../make-test-python.nix ({ lib, ... }:

{
  name = "initrd-network-ssh";
  meta = with lib.maintainers; {
    maintainers = [ willibutz emily ];
  };

  nodes = with lib; {
    server =
      { config, ... }:
      {
        boot.kernelParams = [
          "ip=${config.networking.primaryIPAddress}:::255.255.255.0::eth1:none"
        ];
        boot.initrd.network = {
          enable = true;
          ssh = {
            enable = true;
            authorizedKeys = [ (readFile ./id_ed25519.pub) ];
            port = 22;
            hostKeys = [ ./ssh_host_ed25519_key ];
          };
        };
        boot.initrd.preLVMCommands = ''
          while true; do
            if [ -f fnord ]; then
              poweroff
            fi
            sleep 1
          done
        '';
      };

    client =
      { config, ... }:
      {
        environment.etc = {
          knownHosts = {
            text = concatStrings [
              "server,"
              "${toString (head (splitString " " (
                toString (elemAt (splitString "\n" config.networking.extraHosts) 2)
              )))} "
              "${readFile ./ssh_host_ed25519_key.pub}"
            ];
          };
          sshKey = {
            source = ./id_ed25519;
            mode = "0600";
          };
        };
      };
  };

  testScript = ''
    start_all()
    client.wait_for_unit("network.target")


    def ssh_is_up(_) -> bool:
        status, _ = client.execute("nc -z server 22")
        return status == 0


    with client.nested("waiting for SSH server to come up"):
        retry(ssh_is_up)


    client.succeed(
        "ssh -i /etc/sshKey -o UserKnownHostsFile=/etc/knownHosts server 'touch /fnord'"
    )
    client.shutdown()
  '';
})
