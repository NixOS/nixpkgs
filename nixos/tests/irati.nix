{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with pkgs.lib;

let
  testCases = {
    console = {
      name = "IPCM-Console";
      machine = { config, pkgs, ... }: {
        networking.rina.irati.enable = true;
        environment.systemPackages = [ pkgs.socat ];
      };
      testScript = ''
        startAll;
        $machine->waitForUnit("network.target");
        $machine->succeed("echo show-dif-templates | socat - UNIX:/var/run/ipcm-console.sock | grep normal-ipc");
      '';
    };

    dif-over-vlan = let
      mkSystem = n: { config, pkgs, ... }: with pkgs.lib; {
        boot.extraModprobeConfig = ''
          options rina_irati_core irati_verbosity=7
        '';
        networking = {
          firewall.enable = false;
          useDHCP = false;
          localCommands = ''
            ip link set dev eth1 up
            ip link set dev eth1.100 up
          '';
          vlans."eth1.100" = {
            id = 100;
            interface = "eth1";
          };
          rina.irati = {
            enable = true;
            difs = [
              { name = "100";
                template = "shimeth.system${toString n}.100";
              }
              { name = "Normal.DIF"; }
            ];
            ipcps = [
              { apInstance = "1";
                apName = "eth.1.IPCP";
                difName = "100";
              }
              { apInstance = "1";
                apName = "Normal.${toString n}.IPCP";
                difName = "Normal.DIF";
                difsToRegisterAt = [ "100" ];
              }
            ];
            templates = {
              "shimeth.system${toString n}.100" = {
                configParameters.interface-name = "eth1";
                difType = "shim-eth-vlan";
              };
              "default" = {
                knownIPCProcessAddresses = [
                  { address = 18;
                    apInstance = "1";
                    apName = "Normal.2.IPCP";
                  }
                  { address = 17;
                    apInstance = "1";
                    apName = "Normal.1.IPCP";
                  }
                ];
              };
            };
          };
        };
        systemd.services.rina-echo-time = {
          description = "RINA echo time server";
          serviceConfig.ExecStart = "${pkgs.irati.rina-tools}/bin/rina-echo-time -l";
        };
      };
    in {
      name = "DIF-over-VLAN";
      nodes.system1 = mkSystem 1;
      nodes.system2 = mkSystem 2;
      testScript = { nodes, ... }:
        ''
          startAll;

          $system1->waitForUnit("network.target");
          $system2->waitForUnit("network.target");

          # set up address
          print $system1->succeed("irati-ctl list-ipcps") . "\n";

          print $system1->succeed("irati-ctl enroll-to-dif 2 Normal.DIF 100") . "\n";
          # $res =~ /DIF enrollment succesfully completed/ or die $res;

          print "system1" . $system1->succeed("irati-ctl list-ipcps") . "\n";
          print "system2" . $system2->succeed("irati-ctl list-ipcps") . "\n";

          # Test echo
          $system2->succeed("systemctl start rina-echo-time");
          $system2->waitForUnit("rina-echo-time.service");
          $system1->succeed("sleep 1 && rina-echo-time -c 5");
        '';
    };
  };

in mapAttrs (const (attrs: makeTest (attrs // {
  name = "${attrs.name}-rina";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ rvl ];
  };
}))) testCases
