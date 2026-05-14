{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };

let
  lib = pkgs.lib;

  # Generate EAP certificates on the fly (CA, server, and client certs)
  eapCerts = pkgs.runCommand "eap-certs" { buildInputs = [ pkgs.openssl ]; } ''
    mkdir -p $out

    # Create CA certificate
    openssl req -x509 -newkey rsa:2048 -days 365000 -nodes \
      -keyout $out/ca.key -out $out/ca.cert \
      -subj "/CN=ExampleCA"

    # Create server certificate
    openssl req -newkey rsa:2048 -nodes \
      -keyout $out/server.key -out server.csr \
      -subj "/CN=server.example.com"
    openssl x509 -req -in server.csr -CA $out/ca.cert -CAkey $out/ca.key \
      -days 365000 -set_serial 100 -out $out/server.cert

    # Create client certificate
    openssl req -newkey rsa:2048 -nodes \
      -keyout $out/client1.key -out client1.csr \
      -subj "/CN=client1.example.com"
    openssl x509 -req -in client1.csr -CA $out/ca.cert -CAkey $out/ca.key \
      -days 365000 -set_serial 101 -out $out/client1.cert
  '';

  # this is intended as a client test since you shouldn't use NetworkManager for a router or server
  # so using systemd-networkd for the router vm is fine in these tests.
  router = import ./router.nix { networkd = true; };
  clientConfig =
    extraConfig:
    lib.recursiveUpdate {
      networking.useDHCP = false;

      # Make sure that only NetworkManager configures the interface
      networking.interfaces = lib.mkForce {
        eth1 = { };
      };
      networking.networkmanager = {
        enable = true;
        # this is needed so NM doesn't generate 'Wired Connection' profiles and instead uses the default one
        settings.main.no-auto-default = "*";
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
    startup = {
      name = "startup";
      nodes.client = {
        networking.useDHCP = false;
        networking.networkmanager.enable = true;
      };
      testScript = ''
        with subtest("NetworkManager is started automatically at boot"):
          client.wait_for_unit("NetworkManager.service")
      '';
    };
    static = {
      name = "static";
      nodes = {
        inherit router;
        client = clientConfig {
          networking.networkmanager.ensureProfiles.profiles.default = {
            ipv4.method = "manual";
            ipv4.addresses = "192.168.1.42/24";
            ipv4.gateway = "192.168.1.1";
            ipv6.method = "manual";
            ipv6.addresses = "fd00:1234:5678:1::42/64";
            ipv6.gateway = "fd00:1234:5678:1::1";
          };
        };
      };
      testScript = ''
        start_all()
        router.systemctl("start network-online.target")
        router.wait_for_unit("network-online.target")
        client.wait_for_unit("NetworkManager.service")

        with subtest("Wait until we have an ip address on each interface"):
            client.wait_until_succeeds("ip addr show dev eth1 | grep -q '192.168.1'")
            client.wait_until_succeeds("ip addr show dev eth1 | grep -q 'fd00:1234:5678:1:'")

        with subtest("Test if icmp echo works"):
            client.wait_until_succeeds("ping -c 1 192.168.3.1")
            client.wait_until_succeeds("ping -c 1 fd00:1234:5678:3::1")
            router.wait_until_succeeds("ping -c 1 192.168.1.42")
            router.wait_until_succeeds("ping -c 1 fd00:1234:5678:1::42")
      '';
    };
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
        router.systemctl("start network-online.target")
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
    dns = {
      name = "dns";
      nodes = {
        inherit router;
        dynamic = clientConfig {
          networking.networkmanager.ensureProfiles.profiles.default = {
            ipv4.method = "auto";
          };
        };
        static = clientConfig {
          networking.networkmanager.ensureProfiles.profiles.default = {
            ipv4 = {
              method = "auto";
              ignore-auto-dns = "true";
              dns = "10.10.10.10";
              dns-search = "";
            };
          };
        };
      };
      testScript = ''
        start_all()
        router.systemctl("start network-online.target")
        router.wait_for_unit("network-online.target")
        dynamic.wait_for_unit("NetworkManager.service")
        static.wait_for_unit("NetworkManager.service")

        dynamic.wait_until_succeeds("cat /etc/resolv.conf | grep -q '192.168.1.1'")
        static.wait_until_succeeds("cat /etc/resolv.conf | grep -q '10.10.10.10'")
        static.wait_until_fails("cat /etc/resolv.conf | grep -q '192.168.1.1'")
      '';
    };
    dispatcherScripts = {
      name = "dispatcherScripts";
      nodes.client = clientConfig {
        networking.networkmanager.dispatcherScripts = [
          {
            type = "pre-up";
            source = pkgs.writeText "testHook" ''
              touch /tmp/dispatcher-scripts-are-working
            '';
          }
        ];
      };
      testScript = ''
        start_all()
        client.wait_for_unit("NetworkManager.service")
        client.wait_until_succeeds("stat /tmp/dispatcher-scripts-are-working")
      '';
    };
    envsubst = {
      name = "envsubst";
      nodes.client =
        let
          # you should never write secrets in to your nixos configuration, please use tools like sops-nix or agenix
          secretFile = pkgs.writeText "my-secret.env" ''
            MY_SECRET_IP=fd00:1234:5678:1::23/64
          '';
        in
        clientConfig {
          networking.networkmanager.ensureProfiles.environmentFiles = [ secretFile ];
          networking.networkmanager.ensureProfiles.profiles.default = {
            ipv6.method = "manual";
            ipv6.addresses = "$MY_SECRET_IP";
          };
        };
      testScript = ''
        start_all()
        client.wait_for_unit("NetworkManager.service")
        client.wait_until_succeeds("ip addr show dev eth1 | grep -q 'fd00:1234:5678:1:'")
        client.wait_until_succeeds("ping -c 1 fd00:1234:5678:1::23")
      '';
    };
    eap =
      let
        toBase64Blob =
          file:
          "data:;base64,"
          + builtins.readFile (
            pkgs.runCommand "base64" { } ''
              ${pkgs.coreutils}/bin/base64 -w0 ${file} > $out
            ''
          );
      in
      {
        name = "eap / 802.1x with secrets in blob encoding";
        nodes = {
          router = import ./router-eap.nix { inherit eapCerts; };
          client = clientConfig {
            networking.networkmanager.ensureProfiles.profiles.default = {
              ipv4.method = "auto";
              "802-1x" = {
                eap = "tls";
                identity = "client1.example.com";
                ca-cert = toBase64Blob "${eapCerts}/ca.cert";
                client-cert = toBase64Blob "${eapCerts}/client1.cert";
                private-key = toBase64Blob "${eapCerts}/client1.key";
                private-key-password-flags = "4";
              };
            };
            networking.wireless = {
              # it is a bit unfortunate that wpa-supplicant is equated with
              # `wireless` when it also works for wired connections
              enable = lib.mkOverride 9 true;
              driver = "wired";
            };
          };
        };

        testScript = ''
          start_all()
          client.wait_for_unit("NetworkManager.service")
          router.wait_for_unit("freeradius.service")
          router.wait_for_unit("hostapd.service")
          router.wait_until_succeeds("journalctl -b --unit freeradius.service | grep \"Sent Access-Accept\"")
          router.wait_until_succeeds("journalctl -b --unit freeradius.service | grep \"TLS-Client-Cert-Common-Name := \\\"client1.example.com\\\"\"")
        '';
      };
    eapFiles = {
      name = "eap / 802.1x with secrets in stored in files";
      nodes = {
        router = import ./router-eap.nix { inherit eapCerts; };
        client = clientConfig {
          environment.etc = {
            "wpa_supplicant/ca.cert" = {
              source = "${eapCerts}/ca.cert";
              user = "wpa_supplicant";
              mode = "0400";
            };
            "wpa_supplicant/client1.cert" = {
              source = "${eapCerts}/client1.cert";
              user = "wpa_supplicant";
              mode = "0400";
            };
            "wpa_supplicant/client1.key" = {
              source = "${eapCerts}/client1.key";
              user = "wpa_supplicant";
              mode = "0400";
            };
          };
          networking.networkmanager.ensureProfiles.profiles.default = {
            ipv4.method = "auto";
            "802-1x" = {
              eap = "tls";
              identity = "client1.example.com";
              ca-cert = "/etc/wpa_supplicant/ca.cert";
              client-cert = "/etc/wpa_supplicant/client1.cert";
              private-key = "/etc/wpa_supplicant/client1.key";
              private-key-password-flags = "4";
            };
          };
          networking.wireless = {
            enable = lib.mkOverride 9 true;
            driver = "wired";
          };
        };
      };

      testScript = ''
        start_all()
        client.wait_for_unit("NetworkManager.service")
        router.wait_for_unit("freeradius.service")
        router.wait_for_unit("hostapd.service")
        router.wait_until_succeeds("journalctl -b --unit freeradius.service | grep \"Sent Access-Accept\"")
        router.wait_until_succeeds("journalctl -b --unit freeradius.service | grep \"TLS-Client-Cert-Common-Name := \\\"client1.example.com\\\"\"")
      '';
    };
  };
in
lib.mapAttrs (lib.const (
  attrs:
  makeTest (
    attrs
    // {
      name = "${attrs.name}-Networking-NetworkManager";
      meta = {
        maintainers = [ ];
      };

    }
  )
)) testCases
