{ system ? builtins.currentSystem }:

let
  inherit (import ../../lib/testing.nix { inherit system; }) makeTest pkgs;
in
  with pkgs; lib.listToAttrs ( map (predictable: {

    name = if predictable then "predictable" else "unpredictable";

    value = makeTest {
      name = "initrd-network-ssh"+ lib.optionalString predictable "predictable";
      meta = with lib.maintainers; {
        maintainers = [ willibutz xeji ];
      };

      nodes = with lib;
        let interface2 = if predictable then "ens4" else "eth1";
        in rec {
        server =
          { config, ... }:
          {
            # for stateVersion < 18.09 this doesn't make a difference in initrd
            system.stateVersion = "18.09";
            networking.usePredictableInterfaceNames = mkForce predictable;
            boot.kernelParams = [
              "ip=${config.networking.primaryIPAddress}:::255.255.255.0::${interface2}:none"
            ];
            boot.initrd.network = {
              enable = true;
              # for initrd networking with predictable interface names,
              # udhcpc must be given the name as an argument
              udhcpc.extraArgs = [ (lib.optionalString predictable "-i ${interface2}")];
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
        $client->waitForUnit("network.target");
        $client->copyFileFromHost("${./openssh.priv}","/etc/sshKey");
        $client->succeed("chmod 0600 /etc/sshKey");
        $server->start;
        $client->waitUntilSucceeds("ping -c 1 server");
        $client->succeed("ssh -i /etc/sshKey -o UserKnownHostsFile=/etc/knownHosts server 'touch /fnord'");
        $client->shutdown;
      '';
    };
  }) [false true] 
)
