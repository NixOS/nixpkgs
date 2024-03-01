{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };

let
  lib = pkgs.lib;
  # this is intended as a client test since you shouldn't use NetworkManager for a router or server
  # so using systemd-networkd for the router vm is fine in these tests.
  router = import ./router.nix { networkd = true; };
  clientConfig = extraConfig: lib.recursiveUpdate {
    networking.useDHCP = false;

    # Make sure that only NetworkManager configures the interface
    networking.interfaces = lib.mkForce {
      eth1 = {};
    };
    networking.networkmanager = {
      enable = true;
      # this is needed so NM doesn't generate 'Wired Connection' profiles and instead uses the default one
      extraConfig = ''
        [main]
        no-auto-default=*
      '';
      ensureProfiles.profiles.default = {
        connection = {
          id = "default";
          type = "ethernet";
          interface-name = "eth1";
          autoconnect = true;
        };
      };
    };
  } extraConfig;
  testCases = {
    # static = {
    # };
    auto = {
      name = "auto";
      nodes = {
        inherit router;
        client = clientConfig {
          networking.networkmanager.ensureProfiles.profiles.default = {
            ipv4.method = "auto";
            ipv6.method = "auto";
          };
        };
      };
      testScript = ''
        start_all()
        router.wait_for_unit("network-online.target")
        client.wait_for_unit("NetworkManager.service")

        with subtest("Wait until we have an ip address on each interface"):
            client.wait_until_succeeds("ip addr show dev eth1 | grep -q '192.168.1'")
            client.wait_until_succeeds("ip addr show dev eth1 | grep -q 'fd00:1234:5678:1:'")

        with subtest("Test if icmp echo works"):
            client.wait_until_succeeds("ping -c 1 192.168.1.1")
            client.wait_until_succeeds("ping -c 1 fd00:1234:5678:1::1")
            router.wait_until_succeeds("ping -c 1 192.168.1.2")
            router.wait_until_succeeds("ping -c 1 fd00:1234:5678:1::2")
      '';
    };
    # openvpn = {};
    # wireguard = {};
    # dispatcherScripts = {};
    envsubst = {
      name = "envsubst";
      nodes.client = let
        # you should never put secrets in to your nixos configuration and rather use tools like sops-nix or agenix
        secretFile = pkgs.writeText "my-secret.env" ''
          MY_SECRET_IP=fd00:1234:5678:1::23/64
        '';
      in clientConfig {
        networking.networkmanager.ensureProfiles.environmentFiles = [ secretFile ];
        networking.networkmanager.ensureProfiles.profiles.default = {
          ipv6.method = "manual";
          ipv6.addresses = "$MY_SECRET_IP";
        };
      };
      testScript = ''
        start_all()
        client.wait_for_unit("NetworkManager.service")
        client.succeed("nmcli connection up default")
        client.wait_until_succeeds("ip addr show dev eth1 | grep -q 'fd00:1234:5678:1:'")
        client.wait_until_succeeds("ping -c 1 fd00:1234:5678:1::23")
      '';
    };
  };
in lib.mapAttrs (lib.const (attrs: makeTest (attrs // {
  name = "${attrs.name}-Networking-NetworkManager";
}))) testCases
