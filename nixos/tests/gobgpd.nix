import ./make-test-python.nix ({ pkgs, ... }:
  let
    ifAddr = node: iface: (pkgs.lib.head node.config.networking.interfaces.${iface}.ipv4.addresses).address;
  in {
    name = "gobgpd";

    meta = with pkgs.lib.maintainers; { maintainers = [ higebu ]; };

    nodes = {
      node1 = { nodes, ... }: {
        environment.systemPackages = [ pkgs.gobgp ];
        networking.firewall.allowedTCPPorts = [ 179 ];
        services.gobgpd = {
          enable = true;
          settings = {
            global = {
              config = {
                as = 64512;
                router-id = "192.168.255.1";
              };
            };
            neighbors = [{
              config = {
                neighbor-address = ifAddr nodes.node2 "eth1";
                peer-as = 64513;
              };
            }];
          };
        };
      };
      node2 = { nodes, ... }: {
        environment.systemPackages = [ pkgs.gobgp ];
        networking.firewall.allowedTCPPorts = [ 179 ];
        services.gobgpd = {
          enable = true;
          settings = {
            global = {
              config = {
                as = 64513;
                router-id = "192.168.255.2";
              };
            };
            neighbors = [{
              config = {
                neighbor-address = ifAddr nodes.node1 "eth1";
                peer-as = 64512;
              };
            }];
          };
        };
      };
    };

    testScript = { nodes, ... }: let
      addr1 = ifAddr nodes.node1 "eth1";
      addr2 = ifAddr nodes.node2 "eth1";
    in
      ''
      start_all()

      for node in node1, node2:
          with subtest("should start gobgpd node"):
              node.wait_for_unit("gobgpd.service")
          with subtest("should open port 179"):
              node.wait_for_open_port(179)

      with subtest("should show neighbors by gobgp cli and BGP state should be ESTABLISHED"):
          node1.wait_until_succeeds("gobgp neighbor ${addr2} | grep -q ESTABLISHED")
          node2.wait_until_succeeds("gobgp neighbor ${addr1} | grep -q ESTABLISHED")
    '';
  })
