import ./make-test.nix ({ pkgs, lib, ... }:

let
  keys = pkgs.runCommand "gen-keys" {
    outputs = [ "out" "dbPub" "dbPriv" "sshPub" "sshPriv" ];
    buildInputs = with pkgs; [ dropbear openssh ];
  }
  ''
    touch $out
    dropbearkey -t rsa -f $dbPriv -s 4096 | sed -n 2p > $dbPub
    ssh-keygen -q -t rsa -b 4096 -N "" -f client
    mv client $sshPriv
    mv client.pub $sshPub
  '';

in {
  name = "initrd-network-ssh";
  meta = with lib.maintainers; {
    maintainers = [ willibutz ];
  };

  nodes = with lib; rec {
    server =
      { config, pkgs, ... }:
      {
        boot.kernelParams = [
          "ip=${
            (head config.networking.interfaces.eth1.ip4).address
          }:::255.255.255.0::eth1:none"
        ];
        boot.initrd.network = {
          enable = true;
          ssh = {
            enable = true;
            authorizedKeys = [ "${readFile keys.sshPub}" ];
            port = 22;
            hostRSAKey = keys.dbPriv;
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
      { config, pkgs, ... }:
      {
        environment.etc.knownHosts = {
          text = concatStrings [
            "server,"
            "${toString (head (splitString " " (
              toString (elemAt (splitString "\n" config.networking.extraHosts) 2)
            )))} "
            "${readFile keys.dbPub}"
          ];
        };
      };
  };

  testScript = ''
    startAll;
    $client->waitForUnit("network.target");
    $client->copyFileFromHost("${keys.sshPriv}","/etc/sshKey");
    $client->succeed("chmod 0600 /etc/sshKey");
    $client->waitUntilSucceeds("ping -c 1 server");
    $client->succeed("ssh -i /etc/sshKey -o UserKnownHostsFile=/etc/knownHosts server 'touch /fnord'");
    $client->shutdown;
  '';
})
