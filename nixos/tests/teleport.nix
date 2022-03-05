{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  minimal = { config, ... }: {
    services.teleport.enable = true;
  };

  client = { config, ... }: {
    services.teleport = {
      enable = true;
      settings = {
        teleport = {
          nodename = "client";
          advertise_ip = "192.168.1.20";
          auth_token = "8d1957b2-2ded-40e6-8297-d48156a898a9";
          auth_servers = [ "192.168.1.10:3025" ];
          log.severity = "DEBUG";
        };
        ssh_service = {
          enabled = true;
          labels = {
            role = "client";
          };
        };
        proxy_service.enabled = false;
        auth_service.enabled = false;
      };
    };
    networking.interfaces.eth1.ipv4.addresses = [{
      address = "192.168.1.20";
      prefixLength = 24;
    }];
  };

  server = { config, ... }: {
    services.teleport = {
      enable = true;
      settings = {
        teleport = {
          nodename = "server";
          advertise_ip = "192.168.1.10";
        };
        ssh_service.enabled = true;
        proxy_service.enabled = true;
        auth_service = {
          enabled = true;
          tokens = [ "node:8d1957b2-2ded-40e6-8297-d48156a898a9" ];
        };
      };
      diag.enable = true;
      insecure.enable = true;
    };
    networking = {
      firewall.allowedTCPPorts = [ 3025 ];
      interfaces.eth1.ipv4.addresses = [{
        address = "192.168.1.10";
        prefixLength = 24;
      }];
    };
  };
in
{
  minimal = makeTest {
    # minimal setup should always work
    name = "teleport-minimal-setup";
    meta.maintainers = with pkgs.lib.maintainers; [ ymatsiuk ];
    nodes = { inherit minimal; };

    testScript = ''
      minimal.wait_for_open_port("3025")
      minimal.wait_for_open_port("3080")
      minimal.wait_for_open_port("3022")
    '';
  };

  basic = makeTest {
    # basic server and client test
    name = "teleport-server-client";
    meta.maintainers = with pkgs.lib.maintainers; [ ymatsiuk ];
    nodes = { inherit server client; };

    testScript = ''
      with subtest("teleport ready"):
          server.wait_for_open_port("3025")
          client.wait_for_open_port("3022")

      with subtest("check applied configuration"):
          server.wait_until_succeeds("tctl get nodes --format=json | ${pkgs.jq}/bin/jq -e '.[] | select(.spec.hostname==\"client\") | .metadata.labels.role==\"client\"'")
          server.wait_for_open_port("3000")
          client.succeed("journalctl -u teleport.service --grep='DEBU'")
          server.succeed("journalctl -u teleport.service --grep='Starting teleport in insecure mode.'")
    '';
  };
}
