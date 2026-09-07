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
  eapWifiSsid = "NixOS EAP";
  vwifiPort = 8212;
  vwifiServerAddress = "192.168.1.2";

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
          router.wait_until_succeeds("journalctl -b --unit freeradius.service --grep='Sent Access-Accept'")
          router.wait_until_succeeds("journalctl -b --unit freeradius.service --grep='TLS-Client-Cert-Common-Name = \"client1.example.com\"'")
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
        router.wait_until_succeeds("journalctl -b --unit freeradius.service --grep='Sent Access-Accept'")
        router.wait_until_succeeds("journalctl -b --unit freeradius.service --grep='TLS-Client-Cert-Common-Name = \"client1.example.com\"'")
      '';
    };
    eapPkcs11 = {
      name = "eap / 802.1x over vwifi with a TPM-backed PKCS#11 private key";
      nodes = {
        airgap = {
          networking = {
            useDHCP = false;
            interfaces.eth1.ipv4.addresses = lib.mkForce [
              {
                address = vwifiServerAddress;
                prefixLength = 24;
              }
            ];
          };
          services.vwifi.server = {
            enable = true;
            ports.tcp = vwifiPort;
            openFirewall = true;
          };
          virtualisation.vlans = [ 1 ];
        };
        router = {
          imports = [
            (import ./router-eap.nix {
              inherit eapCerts;
              wifi = {
                interface = "wlan0";
                ssid = eapWifiSsid;
              };
            })
          ];
          services.vwifi = {
            module = {
              enable = true;
              macPrefix = "74:F8:F6:00:01";
            };
            client = {
              enable = true;
              serverAddress = vwifiServerAddress;
              serverPort = vwifiPort;
            };
          };
        };
        client = clientConfig {
          environment = {
            etc = {
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
            };
            systemPackages = [
              pkgs.opensc
              pkgs.p11-kit
            ];
          };

          networking = {
            interfaces = lib.mkForce {
              eth1.ipv4.addresses = [
                {
                  address = "192.168.1.3";
                  prefixLength = 24;
                }
              ];
            };
            networkmanager = {
              unmanaged = [ "eth1" ];
              ensureProfiles.profiles.default = {
                connection = {
                  type = "wifi";
                  interface-name = "wlan0";
                };
                wifi = {
                  ssid = eapWifiSsid;
                  mode = "infrastructure";
                };
                wifi-security.key-mgmt = "wpa-eap";
                ipv4.method = "disabled";
                ipv6.method = "disabled";
                "802-1x" = {
                  eap = "tls";
                  identity = "client1.example.com";
                  ca-cert = "/etc/wpa_supplicant/ca.cert";
                  client-cert = "/etc/wpa_supplicant/client1.cert";
                  private-key = "pkcs11:token=eap;object=client1;type=private";
                  private-key-password = "userpin";
                };
              };
            };
            wireless = {
              enable = lib.mkOverride 9 true;
              driver = "nl80211";
              pkcs11 = {
                enable = true;
                package = pkgs.libp11.overrideAttrs {
                  # TODO: Remove this override once a libp11 release includes the fix for
                  # https://github.com/OpenSC/libp11/issues/672
                  version = "0.4.21-unstable-2026-08-19";
                  src = pkgs.fetchFromGitHub {
                    owner = "OpenSC";
                    repo = "libp11";
                    rev = "e72a2014eb078c7b784e2a9be3e7abd3dce8fd5a";
                    hash = "sha256-V9ZRPUJp2FkK+Zb/qYC13SDE7+oyJ/hlnO/XEN2zDD8=";
                  };
                };
              };
            };
          };

          security.tpm2 = {
            enable = true;
            pkcs11.enable = true;
            tctiEnvironment = {
              enable = true;
              deviceConf = "/dev/tpmrm-test";
            };
          };

          services.udev.extraRules = ''
            KERNEL=="tpmrm0", SYMLINK+="tpmrm-test"
          '';

          services.vwifi = {
            module = {
              enable = true;
              macPrefix = "74:F8:F6:00:02";
            };
            client = {
              enable = true;
              serverAddress = vwifiServerAddress;
              serverPort = vwifiPort;
            };
          };

          systemd.services.tpm2-pkcs11-provision = {
            description = "Provision the TPM2 PKCS#11 token for EAP-TLS";
            requiredBy = [
              "NetworkManager.service"
              "wpa_supplicant.service"
            ];
            before = [
              "NetworkManager.service"
              "wpa_supplicant.service"
            ];
            requires = [ "dev-tpmrm0.device" ];
            after = [
              "dev-tpmrm0.device"
              "systemd-tmpfiles-setup.service"
            ];
            path = [
              pkgs.tpm2-pkcs11
              pkgs.tpm2-tools
            ];
            environment = {
              TPM2TOOLS_TCTI = "device:/dev/tpmrm-test";
              TPM2_PKCS11_STORE = "/etc/tpm2_pkcs11";
            };
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              User = "wpa_supplicant";
              Group = "wpa_supplicant";
              SupplementaryGroups = [ "tss" ];
            };
            script = ''
              test -c /dev/tpmrm-test
              tpm2_ptool init \
                --transient-parent=tpm2-tools-ecc-default \
                --path="$TPM2_PKCS11_STORE"
              tpm2_ptool addtoken \
                --pid=1 \
                --sopin=sopin \
                --userpin=userpin \
                --label=eap \
                --path="$TPM2_PKCS11_STORE"
              tpm2_ptool import \
                --privkey=${eapCerts}/client1.key \
                --algorithm=rsa \
                --label=eap \
                --key-label=client1 \
                --userpin=userpin \
                --path="$TPM2_PKCS11_STORE"
            '';
          };

          virtualisation = {
            tpm.enable = true;
            vlans = [ 1 ];
          };
        };
      };

      testScript = ''
        from datetime import timedelta

        airgap.start()
        airgap.wait_for_unit("vwifi-server.service")
        airgap.wait_for_open_port(${toString vwifiPort})

        router.start()
        router.wait_for_unit("vwifi-client.service")
        router.wait_for_unit("freeradius.service")
        router.wait_for_unit("hostapd.service")

        client.start()
        client.wait_for_unit("vwifi-client.service")
        client.wait_for_unit("tpm2-pkcs11-provision.service")
        client.wait_for_unit("NetworkManager.service")
        client.wait_for_unit("wpa_supplicant.service")

        with subtest("The hardened supplicant can access the configured TPM device"):
            client.succeed("systemctl cat wpa_supplicant.service | grep -F -- '-/dev/tpmrm-test'")
            client.succeed("systemctl cat wpa_supplicant.service | grep -F 'DeviceAllow=/dev/tpmrm-test rw'")
            client.succeed("systemctl show wpa_supplicant.service --property=SupplementaryGroups --value | grep -qw tss")

        with subtest("The supplicant receives the PKCS#11 environment"):
            client.succeed("systemctl show wpa_supplicant.service --property=Environment --value | grep -F 'OPENSSL_ENGINES='")
            client.succeed("systemctl show wpa_supplicant.service --property=Environment --value | grep -F 'TPM2_PKCS11_TCTI=device:/dev/tpmrm-test'")

        with subtest("The TPM-backed private key is available through p11-kit"):
            client.succeed(
                "TPM2_PKCS11_STORE=/etc/tpm2_pkcs11 "
                "TPM2_PKCS11_TCTI=device:/dev/tpmrm-test "
                "pkcs11-tool --module ${lib.getLib pkgs.p11-kit}/lib/p11-kit-proxy.so "
                "--token-label=eap --login --pin=userpin --list-objects --type=privkey "
                "| grep -F client1"
            )

        with subtest("The station connects to the hostapd access point over vwifi"):
            client.wait_until_succeeds(
                "journalctl -b --unit wpa_supplicant.service --grep='wlan0: CTRL-EVENT-CONNECTED'",
                timeout=timedelta(seconds=120),
            )
            client.succeed(
                "nmcli --terse --fields NAME,DEVICE connection show --active "
                "| grep -Fx 'default:wlan0'"
            )

        with subtest("EAP-TLS authenticates with the TPM-backed private key"):
            router.wait_until_succeeds(
                "journalctl -b --unit freeradius.service --grep='Sent Access-Accept'",
                timeout=timedelta(seconds=120),
            )
            router.wait_until_succeeds(
                "journalctl -b --unit freeradius.service --grep='TLS-Client-Cert-Common-Name = \"client1.example.com\"'",
                timeout=timedelta(seconds=120),
            )
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
