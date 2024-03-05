
import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "babeld";
  meta = with pkgs.lib.maintainers; {
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

      local_router = { pkgs, lib, ... }:
      {
        virtualisation.vlans = [ 10 20 ];

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
      remote_router = { pkgs, lib, ... }:
      {
        virtualisation.vlans = [ 20 30 ];

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
      start_all()

      local_router.wait_for_unit("babeld.service")
      remote_router.wait_for_unit("babeld.service")

      local_router.wait_until_succeeds("ip route get 192.168.30.1")
      local_router.wait_until_succeeds("ip route get 2001:db8:30::1")

      remote_router.wait_until_succeeds("ip route get 192.168.10.1")
      remote_router.wait_until_succeeds("ip route get 2001:db8:10::1")

      client.succeed("ping -c1 192.168.30.1")
      client.succeed("ping -c1 2001:db8:30::1")

      remote_router.succeed("ping -c1 192.168.10.2")
      remote_router.succeed("ping -c1 2001:db8:10::2")
    '';
})
