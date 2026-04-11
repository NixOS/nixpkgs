{ pkgs, runTest }:

let

  inherit (pkgs) lib;

  meta = with lib.maintainers; {
    maintainers = [
      oddlama
      rnhmjoj
    ];
  };

  naughtyPassphrase = ''!,./;'[]\-=<>?:"{}|_+@$%^&*()`~ # ceci n'est pas un commentaire'';

  runBssidTest =
    name: expectedBssid: extraConfig:
    runSimulatorTest name extraConfig ''
      with subtest("Daemon can connect to the right access point"):
          machine.wait_for_unit("wpa_supplicant-wlan1.service")
          machine.wait_until_succeeds(
            "wpa_cli -i wlan1 status | grep -q wpa_state=COMPLETED"
          )
          machine.wait_until_succeeds(
            "wpa_cli -i wlan1 status | grep -q bssid=${expectedBssid}"
          )
    '';

  runConnectionTest =
    name: extraConfig:
    runSimulatorTest name extraConfig ''
      with subtest("Daemon can connect to the access point"):
          machine.wait_for_unit("wpa_supplicant-wlan1.service")
          machine.wait_until_succeeds(
            "wpa_cli -i wlan1 status | grep -q wpa_state=COMPLETED"
          )
    '';

  runSimulatorTest =
    name: extraConfig: extraTestScript:
    runTest {
      name = "wpa_supplicant-${name}";
      inherit meta;

      nodes.machine = {
        # add a virtual wlan interface
        boot.kernelModules = [ "mac80211_hwsim" ];

        # wireless access point
        services.hostapd = {
          enable = true;
          radios.wlan0 = {
            band = "2g";
            channel = 6;
            countryCode = "US";
            networks = {
              wlan0 = {
                ssid = "nixos-test-sae";
                authentication = {
                  mode = "wpa3-sae";
                  saePasswords = [ { passwordFile = pkgs.writeText "password" naughtyPassphrase; } ];
                };
                bssid = "02:00:00:00:00:00";
              };
              wlan0-1 = {
                ssid = "nixos-test-mixed";
                authentication = {
                  mode = "wpa3-sae-transition";
                  saeAddToMacAllow = true;
                  saePasswordsFile = pkgs.writeText "password" naughtyPassphrase;
                  wpaPasswordFile = pkgs.writeText "password" naughtyPassphrase;
                };
                bssid = "02:00:00:00:00:01";
              };
              wlan0-2 = {
                ssid = "nixos-test-mixed";
                authentication = {
                  mode = "wpa3-sae-transition";
                  saeAddToMacAllow = true;
                  saePasswordsFile = pkgs.writeText "password" naughtyPassphrase;
                  wpaPasswordFile = pkgs.writeText "password" naughtyPassphrase;
                };
                bssid = "02:00:00:00:00:02";
              };
              wlan0-3 = {
                ssid = "nixos-test-wpa2";
                authentication = {
                  mode = "wpa2-sha256";
                  wpaPassword = naughtyPassphrase;
                };
                bssid = "02:00:00:00:00:03";
              };
            };
          };
        };

        # Note: secrets are stored outside /etc/ and /nix/store to
        # test for accessibility of these paths
        systemd.services.wpa-secrets = {
          wantedBy = [
            "network.target"
            "multi-user.target"
          ];
          before = [
            "network.target"
            "multi-user.target"
          ];
          serviceConfig = {
            Type = "oneshot";
          };
          script =
            let
              secretFile = pkgs.writeText "wpa" ''
                psk_nixos_test=${naughtyPassphrase}
              '';
            in
            ''
              install -Dm600 -o wpa_supplicant ${secretFile} /var/lib/secrets/wpa
            '';
        };

        # wireless client
        networking.wireless = lib.mkMerge [
          {
            # the override is needed because the wifi is
            # disabled with mkVMOverride in qemu-vm.nix.
            enable = lib.mkOverride 0 true;
            userControlled = true;
            interfaces = [ "wlan1" ];
            fallbackToWPA2 = lib.mkDefault true;
            secretsFile = "/var/lib/secrets/wpa";
          }
          extraConfig
        ];
      };

      testScript = ''
        # save hostapd config file for manual inspection
        machine.wait_for_unit("hostapd.service")
        machine.copy_from_vm("/run/hostapd/wlan0.hostapd.conf")

        ${extraTestScript}
      '';
    };

in

{
  # Test the basic setup:
  #   - automatic interface discovery
  #   - WPA2 fallbacks
  #   - connecting to the daemon
  basic = runTest {
    name = "wpa_supplicant-basic";
    inherit meta;

    nodes.machine = {
      # add a virtual wlan interface
      boot.kernelModules = [ "mac80211_hwsim" ];

      # wireless client
      networking.wireless = {
        # the override is needed because the wifi is
        # disabled with mkVMOverride in qemu-vm.nix.
        enable = lib.mkOverride 0 true;
        userControlled = true;
        dbusControlled = true;
        fallbackToWPA2 = true;

        networks = {
          # test WPA2 fallback
          mixed-wpa = {
            psk = "password";
            authProtocols = [
              "WPA-PSK"
              "SAE"
            ];
          };
          sae-only = {
            psk = "password";
            authProtocols = [ "SAE" ];
          };

          # Test duplicate SSID generation
          duplicate1 = {
            ssid = "duplicate";
            bssid = "00:00:00:00:00:01";
            psk = "password";
          };
          duplicate2 = {
            ssid = "duplicate";
            bssid = "00:00:00:00:00:02";
            psk = "password";
          };
        };

        extraConfigFiles = [
          (pkgs.writeText "test1.conf" ''
            network={
              ssid="test1"
              key_mgmt=WPA-PSK
              psk="password1"
            }
          '')
          (pkgs.writeText "test2.conf" ''
            network={
              ssid="test2"
              key_mgmt=WPA-PSK
              psk="password2"
            }
          '')
        ];
      };
    };

    testScript = ''
      with subtest("Daemon is running and accepting connections"):
          machine.wait_for_unit("wpa_supplicant.service")
          status = machine.wait_until_succeeds("wpa_cli status")
          assert "Failed to connect" not in status, \
                 "Failed to connect to the daemon"

      with subtest("D-Bus interface is working"):
          dbus_command = "dbus-send --system --print-reply --dest=fi.w1.wpa_supplicant1 " \
                         "/fi/w1/wpa_supplicant1 fi.w1.wpa_supplicant1.GetInterface string:wlan0"
          machine.succeed(dbus_command)  # as root
          machine.succeed(f"sudo -g wpa_supplicant {dbus_command}")  # as wpa_supplicant group

      with subtest("D-Bus auto-starting is working"):
          # stop service
          machine.systemctl("stop wpa_supplicant.service")
          machine.require_unit_state("wpa_supplicant.service", "inactive")

          # send wake up
          dbus_command = "dbus-send --system --print-reply --dest=fi.w1.wpa_supplicant1 " \
                         "/fi/w1/wpa_supplicant1 fi.w1.wpa_supplicant1.GetInterface string:wlan0"
          machine.succeed(dbus_command)

          # should be up again
          machine.require_unit_state("wpa_supplicant.service", "active")

      # generated configuration file
      config_file = "/etc/static/wpa_supplicant/nixos.conf"

      with subtest("WPA2 fallbacks have been generated"):
          assert int(machine.succeed(f"grep -c sae-only {config_file}")) == 1
          assert int(machine.succeed(f"grep -c mixed-wpa {config_file}")) == 2

      with subtest("Duplicate SSID network blocks have been generated"):
          # more duplication due to fallbacks
          assert int(machine.succeed(f"grep -c duplicate {config_file}")) == 4
          assert int(machine.succeed(f"grep -c bssid=00:00:00:00:00:01 {config_file}")) == 2
          assert int(machine.succeed(f"grep -c bssid=00:00:00:00:00:02 {config_file}")) == 2

      with subtest("Extra config files have been loaded"):
          machine.wait_until_succeeds("wpa_cli -i wlan0 list_networks | grep -q test1")
          machine.succeed("wpa_cli -i wlan0 list_networks | grep -q test2")

      # save file for manual inspection
      machine.copy_from_vm(config_file)

      # check hardening options
      machine.succeed("systemd-analyze security wpa_supplicant >&2")
    '';
  };

  # Test configuring the daemon imperatively
  imperative = runTest {
    name = "wpa_supplicant-imperative";
    inherit meta;

    nodes.machine = {
      # add a virtual wlan interface
      boot.kernelModules = [ "mac80211_hwsim" ];

      # wireless client
      networking.wireless = {
        enable = lib.mkOverride 0 true;
        userControlled = true;
        allowAuxiliaryImperativeNetworks = true;
        interfaces = [ "wlan1" ];
      };
    };

    testScript = ''
      wpa_cli = "sudo -u nobody -g wpa_supplicant wpa_cli"

      with subtest("Daemon is running and accepting connections"):
          machine.wait_for_unit("wpa_supplicant-wlan1.service")
          status = machine.wait_until_succeeds(f"{wpa_cli} -i wlan1 status")
          assert "Failed to connect" not in status, \
                 "Failed to connect to the daemon"

      with subtest("Daemon can be configured imperatively"):
          machine.succeed(f"{wpa_cli} -i wlan1 add_network")
          machine.succeed(f"{wpa_cli} -i wlan1 set_network 0 ssid '\"nixos-test\"'")
          machine.succeed(f"{wpa_cli} -i wlan1 set_network 0 psk '\"reproducibility\"'")
          machine.succeed(f"{wpa_cli} -i wlan1 save_config")
          machine.succeed("grep -q nixos-test /etc/wpa_supplicant/imperative.conf")
    '';
  };

  # Test connecting to a SAE-only hotspot using SAE
  saeOnly = runConnectionTest "sae-only" {
    fallbackToWPA2 = false;
    networks.nixos-test-sae = {
      pskRaw = "ext:psk_nixos_test";
      authProtocols = [ "SAE" ];
    };
  };

  # Test connecting to a mixed SAE/WPA2 hotspot using SAE
  mixedUsingSae = runConnectionTest "mixed-using-sae" {
    fallbackToWPA2 = false;
    networks.nixos-test-mixed = {
      pskRaw = "ext:psk_nixos_test";
      authProtocols = [ "SAE" ];
    };
  };

  # Test connecting to a mixed SAE/WPA2 hotspot using WPA2
  mixedUsingWpa2 = runConnectionTest "mixed-using-wpa2" {
    fallbackToWPA2 = true;
    networks.nixos-test-mixed = {
      pskRaw = "ext:psk_nixos_test";
      authProtocols = [ "WPA-PSK-SHA256" ];
    };
  };

  # Test connecting to a legacy WPA2-only hotspot using WPA2
  legacy = runConnectionTest "legacy" {
    fallbackToWPA2 = true;
    networks.nixos-test-wpa2 = {
      pskRaw = "ext:psk_nixos_test";
      authProtocols = [ "WPA-PSK-SHA256" ];
    };
  };

  # Test connection with the highest prio "matching" network block found.
  # "Matching" meaning with the right SSID and BSSID
  bssidGuard = runBssidTest "bssid-guard" "02:00:00:00:00:02" {
    networks = {
      "1_first" = {
        ssid = "nixos-test-mixed";
        bssid = "02:00:00:00:00:01";
        pskRaw = "ext:psk_nixos_test";
      };
      "2_second" = {
        ssid = "nixos-test-mixed";
        bssid = "02:00:00:00:00:02";
        pskRaw = "ext:psk_nixos_test";
        priority = 1;
      };
    };
  };

}
