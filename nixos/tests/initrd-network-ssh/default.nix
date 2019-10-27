import ../make-test.nix ({ lib, ... }:

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
        environment.etc.knownHosts = {
          text = concatStrings [
            "server,"
            "${toString (head (splitString " " (
              toString (elemAt (splitString "\n" config.networking.extraHosts) 2)
            )))} "
            "${readFile ./dropbear.pub}"
          ];
        };
      };
  };

  testScript = ''
    startAll;
    $client->waitForUnit("network.target");
    $client->copyFileFromHost("${./openssh.priv}","/etc/sshKey");
    $client->succeed("chmod 0600 /etc/sshKey");
    $client->waitUntilSucceeds("ping -c 1 server");
    $client->succeed("ssh -i /etc/sshKey -o UserKnownHostsFile=/etc/knownHosts server 'touch /fnord'");
    $client->shutdown;
  '';
})
