
import ./make-test.nix ({ pkgs, lib, ...} : {
  name = "babeld";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ hexa ];
  };

  nodes =
    { client = { pkgs, lib, ... }:
      {
        virtualisation.vlans = [ 10 ];

        networking = {
          useDHCP = false;
          interfaces."eth1" = {
            ipv4.addresses = lib.mkForce [ { address = "192.168.10.2"; prefixLength = 24; } ];
            ipv4.routes = lib.mkForce [ { address = "0.0.0.0"; prefixLength = 0; via = "192.168.10.1"; } ];
            ipv6.addresses = lib.mkForce [ { address = "2001:db8:10::2"; prefixLength = 64; } ];
            ipv6.routes = lib.mkForce [ { address = "::"; prefixLength = 0; via = "2001:db8:10::1"; } ];
          };
        };
      };

      localRouter = { pkgs, lib, ... }:
      {
        virtualisation.vlans = [ 10 20 ];

        boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = 1;
        boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

        networking = {
          useDHCP = false;
          firewall.enable = false;

          interfaces."eth1" = {
            ipv4.addresses = lib.mkForce [ { address = "192.168.10.1"; prefixLength = 24; } ];
            ipv6.addresses = lib.mkForce [ { address = "2001:db8:10::1"; prefixLength = 64; } ];
          };

          interfaces."eth2" = {
            ipv4.addresses = lib.mkForce [ { address = "192.168.20.1"; prefixLength = 24; } ];
            ipv6.addresses = lib.mkForce [ { address = "2001:db8:20::1"; prefixLength = 64; } ];
          };
        };

        services.babeld = {
          enable = true;
          interfaces.eth2 = {
            hello-interval = 1;
            type = "wired";
          };
          extraConfig = ''
            local-port-readwrite 33123

            import-table 254 # main
            export-table 254 # main

            in ip 192.168.10.0/24 deny
            in ip 192.168.20.0/24 deny
            in ip 2001:db8:10::/64 deny
            in ip 2001:db8:20::/64 deny

            in ip 192.168.30.0/24 allow
            in ip 2001:db8:30::/64 allow

            in deny

            redistribute local proto 2
            redistribute local deny
          '';
        };
      };
      remoteRouter = { pkgs, lib, ... }:
      {
        virtualisation.vlans = [ 20 30 ];

        boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = 1;
        boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

        networking = {
          useDHCP = false;
          firewall.enable = false;

          interfaces."eth1" = {
            ipv4.addresses = lib.mkForce [ { address = "192.168.20.2"; prefixLength = 24; } ];
            ipv6.addresses = lib.mkForce [ { address = "2001:db8:20::2"; prefixLength = 64; } ];
          };

          interfaces."eth2" = {
            ipv4.addresses = lib.mkForce [ { address = "192.168.30.1"; prefixLength = 24; } ];
            ipv6.addresses = lib.mkForce [ { address = "2001:db8:30::1"; prefixLength = 64; } ];
          };
        };

        services.babeld = {
          enable = true;
          interfaces.eth1 = {
            hello-interval = 1;
            type = "wired";
          };
          extraConfig = ''
            local-port-readwrite 33123

            import-table 254 # main
            export-table 254 # main

            in ip 192.168.20.0/24 deny
            in ip 192.168.30.0/24 deny
            in ip 2001:db8:20::/64 deny
            in ip 2001:db8:30::/64 deny

            in ip 192.168.10.0/24 allow
            in ip 2001:db8:10::/64 allow

            in deny

            redistribute local proto 2
            redistribute local deny
          '';
        };

      };
    };

  testScript =
    ''
      startAll;

      $client->waitForUnit("network-online.target");
      $localRouter->waitForUnit("network-online.target");
      $remoteRouter->waitForUnit("network-online.target");

      $localRouter->waitForUnit("babeld.service");
      $remoteRouter->waitForUnit("babeld.service");

      $localRouter->waitUntilSucceeds("ip route get 192.168.30.1");
      $localRouter->waitUntilSucceeds("ip route get 2001:db8:30::1");

      $remoteRouter->waitUntilSucceeds("ip route get 192.168.10.1");
      $remoteRouter->waitUntilSucceeds("ip route get 2001:db8:10::1");

      $client->succeed("ping -c1 192.168.30.1");
      $client->succeed("ping -c1 2001:db8:30::1");

      $remoteRouter->succeed("ping -c1 192.168.10.2");
      $remoteRouter->succeed("ping -c1 2001:db8:10::2");
    '';
})
