# This strongswan-swanctl test is based on:
# https://www.strongswan.org/testing/testresults/swanctl/rw-psk-ipv4/index.html
# https://github.com/strongswan/strongswan/tree/master/testing/tests/swanctl/rw-psk-ipv4
#
# The roadwarrior carol sets up a connection to gateway moon. The authentication
# is based on pre-shared keys and IPv4 addresses. Upon the successful
# establishment of the IPsec tunnels, the specified updown script automatically
# inserts iptables-based firewall rules that let pass the tunneled traffic. In
# order to test both tunnel and firewall, carol pings the client alice behind
# the gateway moon.
#
#     alice                       moon                        carol
#      eth1------vlan_0------eth1        eth2------vlan_1------eth1
#   192.168.0.1         192.168.0.3  192.168.1.3           192.168.1.2
#
# See the NixOS manual for how to run this test:
# https://nixos.org/nixos/manual/index.html#sec-running-nixos-tests-interactively

import ./make-test-python.nix ({ pkgs, ...} :

let
  allowESP = "iptables --insert INPUT --protocol ESP --jump ACCEPT";

  # Shared VPN settings:
  vlan0         = "192.168.0.0/24";
  carolIp       = "192.168.1.2";
  moonIp        = "192.168.1.3";
  version       = 2;
  secret        = "0sFpZAZqEN6Ti9sqt4ZP5EWcqx";
  esp_proposals = [ "aes128gcm128-x25519" ];
  proposals     = [ "aes128-sha256-x25519" ];
in {
  name = "strongswan-swanctl";
  meta.maintainers = with pkgs.lib.maintainers; [ basvandijk ];
  nodes = {

    alice = { ... } : {
      virtualisation.vlans = [ 0 ];
      networking = {
        dhcpcd.enable = false;
        defaultGateway = "192.168.0.3";
      };
    };

    moon = { config, ...} :
      let strongswan = config.services.strongswan-swanctl.package;
      in {
        virtualisation.vlans = [ 0 1 ];
        networking = {
          dhcpcd.enable = false;
          firewall = {
            allowedUDPPorts = [ 4500 500 ];
            extraCommands = allowESP;
          };
          nat = {
            enable             = true;
            internalIPs        = [ vlan0 ];
            internalInterfaces = [ "eth1" ];
            externalIP         = moonIp;
            externalInterface  = "eth2";
          };
        };
        environment.systemPackages = [ strongswan ];
        services.strongswan-swanctl = {
          enable = true;
          swanctl = {
            connections = {
              rw = {
                local_addrs = [ moonIp ];
                local.main = {
                  auth = "psk";
                };
                remote.main = {
                  auth = "psk";
                };
                children = {
                  net = {
                    local_ts = [ vlan0 ];
                    updown = "${strongswan}/libexec/ipsec/_updown iptables";
                    inherit esp_proposals;
                  };
                };
                inherit version;
                inherit proposals;
              };
            };
            secrets = {
              ike.carol = {
                id.main = carolIp;
                inherit secret;
              };
            };
          };
        };
      };

    carol = { config, ...} :
      let strongswan = config.services.strongswan-swanctl.package;
      in {
        virtualisation.vlans = [ 1 ];
        networking = {
          dhcpcd.enable = false;
          firewall.extraCommands = allowESP;
        };
        environment.systemPackages = [ strongswan ];
        services.strongswan-swanctl = {
          enable = true;
          swanctl = {
            connections = {
              home = {
                local_addrs = [ carolIp ];
                remote_addrs = [ moonIp ];
                local.main = {
                  auth = "psk";
                  id = carolIp;
                };
                remote.main = {
                  auth = "psk";
                  id = moonIp;
                };
                children = {
                  home = {
                    remote_ts = [ vlan0 ];
                    start_action = "trap";
                    updown = "${strongswan}/libexec/ipsec/_updown iptables";
                    inherit esp_proposals;
                  };
                };
                inherit version;
                inherit proposals;
              };
            };
            secrets = {
              ike.moon = {
                id.main = moonIp;
                inherit secret;
              };
            };
          };
        };
      };

  };
  testScript = ''
    start_all()
    carol.wait_until_succeeds("ping -c 1 alice")
  '';
})
