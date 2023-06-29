import ./make-test-python.nix ({lib, pkgs, ... }: {
  name = "jool";

  meta.maintainers = with lib.maintainers; [ apfelkuchen6 ];

  nodes = {
    plat = { self, config, pkgs, ... }: {
      virtualisation.vlans = [ 1 2 ];
      networking = {
        useNetworkd = true;
        useDHCP = false;
        firewall.enable = false;
      };
      systemd.network.networks = {
        "01-eth1" = {
          name = "eth1";
          address = [ "2001:db8::64/64" ];
        };
        "02-legacynet" = {
          name = "eth2";
          address = [ "172.16.0.64/24" ];
        };
      };
      services.jool-nat64.enable = true;
    };
    client = {
      virtualisation.vlans = [ 1 ];
      networking = {
        useNetworkd = true;
        useDHCP = false;
      };
      systemd.network.networks."01-lan" = {
        name = "eth1";
        address = [ "2001:db8::1/64" ];
        routes = [{
          routeConfig = {
            Gateway = "2001:db8::64";
            Destination = "64:ff9b::/96";
          };
        }];
      };
    };
    legacy = {
      virtualisation.vlans = [ 2 ];
      networking = {
        useNetworkd = true;
        useDHCP = false;
      };
      systemd.network.networks."02-legacynet" = {
        name = "eth1";
        address = [ "172.16.0.2/24" ];
      };
    };
  };
  testScript = ''
    start_all()
    plat.wait_for_unit("systemd-networkd-wait-online.service")
    legacy.wait_for_unit("systemd-networkd-wait-online.service")
    client.wait_for_unit("systemd-networkd-wait-online.service")
    plat.wait_for_unit("jool-nat64-default.service");

    client.succeed("ping -c 1 64:ff9b::172.16.0.2")
  '';
})
