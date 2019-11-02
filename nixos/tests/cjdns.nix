let
  carolKey = "2d2a338b46f8e4a8c462f0c385b481292a05f678e19a2b82755258cf0f0af7e2";
  carolPubKey = "n932l3pjvmhtxxcdrqq2qpw5zc58f01vvjx01h4dtd1bb0nnu2h0.k";
  carolPassword = "678287829ce4c67bc8b227e56d94422ee1b85fa11618157b2f591de6c6322b52";

  basicConfig =
    { ... }:
    { services.cjdns.enable = true;

      # Turning off DHCP isn't very realistic but makes
      # the sequence of address assignment less stochastic.
      networking.useDHCP = false;

      # CJDNS output is incompatible with the XML log.
      systemd.services.cjdns.serviceConfig.StandardOutput = "null";
    };

in

import ./make-test.nix ({ pkgs, ...} : {
  name = "cjdns";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ehmry ];
  };

  nodes = { # Alice finds peers over over ETHInterface.
      alice =
        { ... }:
        { imports = [ basicConfig ];

          services.cjdns.ETHInterface.bind = "eth1";

          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
          networking.firewall.allowedTCPPorts = [ 80 ];
        };

      # Bob explicitly connects to Carol over UDPInterface.
      bob =
        { ... }:

        { imports = [ basicConfig ];

          networking.interfaces.eth1.ipv4.addresses = [
            { address = "192.168.0.2"; prefixLength = 24; }
          ];

          services.cjdns =
            { UDPInterface =
                { bind = "0.0.0.0:1024";
                  connectTo."192.168.0.1:1024" =
                    { password = carolPassword;
                      publicKey = carolPubKey;
                    };
                };
            };
        };

      # Carol listens on ETHInterface and UDPInterface,
      # but knows neither Alice or Bob.
      carol =
        { ... }:
        { imports = [ basicConfig ];

          environment.etc."cjdns.keys".text = ''
            CJDNS_PRIVATE_KEY=${carolKey}
            CJDNS_ADMIN_PASSWORD=FOOBAR
          '';

          networking.interfaces.eth1.ipv4.addresses = [
            { address = "192.168.0.1"; prefixLength = 24; }
          ];

          services.cjdns =
            { authorizedPasswords = [ carolPassword ];
              ETHInterface.bind = "eth1";
              UDPInterface.bind = "192.168.0.1:1024";
            };
          networking.firewall.allowedUDPPorts = [ 1024 ];
        };

    };

  testScript =
    ''
      startAll;

      $alice->waitForUnit("cjdns.service");
      $bob->waitForUnit("cjdns.service");
      $carol->waitForUnit("cjdns.service");

      sub cjdnsIp {
          my ($machine) = @_;
          my $ip = (split /[ \/]+/, $machine->succeed("ip -o -6 addr show dev tun0"))[3];
          $machine->log("has ip $ip");
          return $ip;
      }

      my $aliceIp6 = cjdnsIp $alice;
      my $bobIp6   = cjdnsIp $bob;
      my $carolIp6 = cjdnsIp $carol;

      # ping a few times each to let the routing table establish itself

      $alice->succeed("ping -c 4 $carolIp6");
      $bob->succeed("ping -c 4 $carolIp6");

      $carol->succeed("ping -c 4 $aliceIp6");
      $carol->succeed("ping -c 4 $bobIp6");

      $alice->succeed("ping -c 4 $bobIp6");
      $bob->succeed("ping -c 4 $aliceIp6");

      $alice->waitForUnit("httpd.service");

      $bob->succeed("curl --fail -g http://[$aliceIp6]");
    '';
})
