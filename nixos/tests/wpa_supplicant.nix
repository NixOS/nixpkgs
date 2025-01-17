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

  runConnectionTest =
    name: extraConfig:
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
                  saePasswords = [ { password = naughtyPassphrase; } ];
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
                ssid = "nixos-test-wpa2";
                authentication = {
                  mode = "wpa2-sha256";
                  wpaPassword = naughtyPassphrase;
                };
                bssid = "02:00:00:00:00:02";
              };
            };
          };
        };

        # wireless client
        networking.wireless = lib.mkMerge [
          {
            # the override is needed because the wifi is
            # disabled with mkVMOverride in qemu-vm.nix.
            enable = lib.mkOverride 0 true;
            userControlled.enable = true;
            interfaces = [ "wlan1" ];
            fallbackToWPA2 = lib.mkDefault true;

            # secrets
            secretsFile = pkgs.writeText "wpa-secrets" ''
              psk_nixos_test=${naughtyPassphrase}
            '';
          }
          extraConfig
        ];
      };

      testScript = ''
        # save hostapd config file for manual inspection
        machine.wait_for_unit("hostapd.service")
        machine.copy_from_vm("/run/hostapd/wlan0.hostapd.conf")

        with subtest("Daemon can connect to the access point"):
            machine.wait_for_unit("wpa_supplicant-wlan1.service")
            machine.wait_until_succeeds(
              "wpa_cli -i wlan1 status | grep -q wpa_state=COMPLETED"
            )
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
        userControlled.enable = true;
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
        };
      };
    };

    testScript = ''
      with subtest("Daemon is running and accepting connections"):
          machine.wait_for_unit("wpa_supplicant.service")
          status = machine.wait_until_succeeds("wpa_cli status")
          assert "Failed to connect" not in status, \
                 "Failed to connect to the daemon"

      # get the configuration file
      cmdline = machine.succeed("cat /proc/$(pgrep wpa)/cmdline").split('\x00')
      config_file = cmdline[cmdline.index("-c") + 1]

      with subtest("WPA2 fallbacks have been generated"):
          assert int(machine.succeed(f"grep -c sae-only {config_file}")) == 1
          assert int(machine.succeed(f"grep -c mixed-wpa {config_file}")) == 2

      # save file for manual inspection
      machine.copy_from_vm(config_file)
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
        userControlled.enable = true;
        allowAuxiliaryImperativeNetworks = true;
        interfaces = [ "wlan1" ];
      };
    };

    testScript = ''
      with subtest("Daemon is running and accepting connections"):
          machine.wait_for_unit("wpa_supplicant-wlan1.service")
          status = machine.wait_until_succeeds("wpa_cli -i wlan1 status")
          assert "Failed to connect" not in status, \
                 "Failed to connect to the daemon"

      with subtest("Daemon can be configured imperatively"):
          machine.succeed("wpa_cli -i wlan1 add_network")
          machine.succeed("wpa_cli -i wlan1 set_network 0 ssid '\"nixos-test\"'")
          machine.succeed("wpa_cli -i wlan1 set_network 0 psk '\"reproducibility\"'")
          machine.succeed("wpa_cli -i wlan1 save_config")
          machine.succeed("grep -q nixos-test /etc/wpa_supplicant.conf")
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
}
