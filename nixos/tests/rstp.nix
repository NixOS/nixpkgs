{ pkgs, lib, ... }:
{
  name = "rstp";

  nodes = {
    client = {
      containers = {
        peer = {
          autoStart = true;
          privateNetwork = true;
          hostBridge = "br0";

          config = {
            networking = {
              interfaces = {
                eth0 = {
                  ipv4.addresses = [
                    {
                      address = "192.168.1.122";
                      prefixLength = 24;
                    }
                  ];
                };
              };
            };
          };
        };
      };

      networking = {
        bridges = {
          br0 = {
            interfaces = [ ];
            rstp = true;
          };
        };

        interfaces = {
          eth1 = {
            ipv4.addresses = lib.mkForce [ ];
            ipv6.addresses = lib.mkForce [ ];
          };

          br0 = {
            ipv4.addresses = [
              {
                address = "192.168.1.2";
                prefixLength = 24;
              }
            ];
          };
        };
      };

      virtualisation = {
        vlans = [ 1 ];
      };
    };
  };

  testScript = ''
    client.start()
    client.wait_for_unit("default.target")
    client.wait_until_succeeds("journalctl | grep 'Port vb-peer : up'", timeout=10)
  '';
}
