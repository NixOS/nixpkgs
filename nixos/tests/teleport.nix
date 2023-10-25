{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
, lib ? pkgs.lib
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  packages = with pkgs; {
    "default" = teleport;
    "11" = teleport_11;
  };

  minimal = package: {
    services.teleport = {
      enable = true;
      inherit package;
    };
  };

  client = package: {
    services.teleport = {
      enable = true;
      inherit package;
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

  server = package: {
    services.teleport = {
      enable = true;
      inherit package;
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
lib.concatMapAttrs
  (name: package: {
    "minimal_${name}" = makeTest {
      # minimal setup should always work
      name = "teleport-minimal-setup";
      meta.maintainers = with pkgs.lib.maintainers; [ justinas ];
      nodes.minimal = minimal package;

      testScript = ''
        minimal.wait_for_open_port(3025)
        minimal.wait_for_open_port(3080)
        minimal.wait_for_open_port(3022)
      '';
    };

    "basic_${name}" = makeTest {
      # basic server and client test
      name = "teleport-server-client";
      meta.maintainers = with pkgs.lib.maintainers; [ justinas ];
      nodes = {
        server = server package;
        client = client package;
      };

      testScript = ''
        with subtest("teleport ready"):
            server.wait_for_open_port(3025)
            client.wait_for_open_port(3022)

        with subtest("check applied configuration"):
            server.wait_until_succeeds("tctl get nodes --format=json | ${pkgs.jq}/bin/jq -e '.[] | select(.spec.hostname==\"client\") | .metadata.labels.role==\"client\"'")
            server.wait_for_open_port(3000)
            client.succeed("journalctl -u teleport.service --grep='DEBU'")
            server.succeed("journalctl -u teleport.service --grep='Starting teleport in insecure mode.'")
      '';
    };
  })
  packages
