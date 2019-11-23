import ../make-test-python.nix ({ lib, ... }:

{
  name = "initrd-network-ssh";
  meta = with lib.maintainers; {
    maintainers = [ willibutz ];
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
            authorizedKeys = [ "${readFile ./openssh.pub}" ];
            port = 22;
            hostRSAKey = ./dropbear.priv;
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
              "${readFile ./dropbear.pub}"
            ];
          };
          sshKey = {
            source = ./openssh.priv; # dont use this anywhere else
            mode = "0600";
          };
        };
      };
  };

  testScript = ''
    start_all()
    client.wait_for_unit("network.target")
    client.wait_until_succeeds("ping -c 1 server")
    client.succeed(
        "ssh -i /etc/sshKey -o UserKnownHostsFile=/etc/knownHosts server 'touch /fnord'"
    )
    client.shutdown()
  '';
})
