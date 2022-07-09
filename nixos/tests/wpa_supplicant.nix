import ./make-test-python.nix ({ pkgs, lib, ...}:
{
  name = "wpa_supplicant";
  meta = with lib.maintainers; {
    maintainers = [ oddlama rnhmjoj ];
  };

  nodes = let
    machineWithHostapd = extraConfigModule: { ... }: {
      imports = [
        ../modules/profiles/minimal.nix
        extraConfigModule
      ];

      # add a virtual wlan interface
      boot.kernelModules = [ "mac80211_hwsim" ];

      # wireless access point
      services.hostapd = {
        enable = true;
        radios.wlan0 = {
          band = "2g";
          countryCode = "US";
          networks = {
            wlan0 = {
              ssid = "nixos-test-sae";
              authentication = {
                mode = "wpa3-sae";
                saePasswords = [ { password = "reproducibility"; } ];
              };
              bssid = "02:00:00:00:00:00";
            };
            wlan0-1 = {
              ssid = "nixos-test-mixed";
              authentication = {
                mode = "wpa3-sae-transition";
                saeAddToMacAllow = true;
                saePasswordsFile = pkgs.writeText "password" "reproducibility";
                wpaPasswordFile = pkgs.writeText "password" "reproducibility";
              };
              bssid = "02:00:00:00:00:01";
            };
            wlan0-2 = {
              ssid = "nixos-test-wpa2";
              authentication = {
                mode = "wpa2-sha256";
                wpaPassword = "reproducibility";
              };
              bssid = "02:00:00:00:00:02";
            };
          };
        };
      };

      # wireless client
      networking.wireless = {
        # the override is needed because the wifi is
        # disabled with mkVMOverride in qemu-vm.nix.
        enable = lib.mkOverride 0 true;
        userControlled.enable = true;
        interfaces = [ "wlan1" ];
        fallbackToWPA2 = lib.mkDefault true;

        # networks will be added on-demand below for the specific
        # network that should be tested

        # secrets
        secretsFile = pkgs.writeText "wpa-secrets" ''
          psk_nixos_test="reproducibility"
        '';
      };
    };
  in {
    basic = { ... }: {
      imports = [ ../modules/profiles/minimal.nix ];

      # add a virtual wlan interface
      boot.kernelModules = [ "mac80211_hwsim" ];

      # wireless client
      networking.wireless = {
        # the override is needed because the wifi is
        # disabled with mkVMOverride in qemu-vm.nix.
        enable = lib.mkOverride 0 true;
        userControlled.enable = true;
        interfaces = [ "wlan1" ];
        fallbackToWPA2 = true;

        networks = {
          # test WPA2 fallback
          mixed-wpa = {
            psk = "password";
            authProtocols = [ "WPA-PSK" "SAE" ];
          };
          sae-only = {
            psk = "password";
            authProtocols = [ "SAE" ];
          };
        };
      };
    };

    imperative = { ... }: {
      imports = [ ../modules/profiles/minimal.nix ];

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

    # Test connecting to the SAE-only hotspot using SAE
    machineSae = machineWithHostapd {
      networking.wireless = {
        fallbackToWPA2 = false;
        networks.nixos-test-sae = {
          pskRaw = "ext:psk_nixos_test";
          authProtocols = [ "SAE" ];
        };
      };
    };

    # Test connecting to the SAE and WPA2 mixed hotspot using SAE
    machineMixedUsingSae = machineWithHostapd {
      networking.wireless = {
        fallbackToWPA2 = false;
        networks.nixos-test-mixed = {
          pskRaw = "ext:psk_nixos_test";
          authProtocols = [ "SAE" ];
        };
      };
    };

    # Test connecting to the SAE and WPA2 mixed hotspot using WPA2
    machineMixedUsingWpa2 = machineWithHostapd {
      networking.wireless = {
        fallbackToWPA2 = true;
        networks.nixos-test-mixed = {
          pskRaw = "ext:psk_nixos_test";
          authProtocols = [ "WPA-PSK-SHA256" ];
        };
      };
    };

    # Test connecting to the WPA2 legacy hotspot using WPA2
    machineWpa2 = machineWithHostapd {
      networking.wireless = {
        fallbackToWPA2 = true;
        networks.nixos-test-wpa2 = {
          pskRaw = "ext:psk_nixos_test";
          authProtocols = [ "WPA-PSK-SHA256" ];
        };
      };
    };
  };

  testScript =
    ''
      # get the configuration file
      basic.wait_for_unit("wpa_supplicant-wlan1.service")
      cmdline = basic.succeed("cat /proc/$(pgrep wpa)/cmdline").split('\x00')
      config_file = cmdline[cmdline.index("-c") + 1]

      with subtest("WPA2 fallbacks have been generated"):
          assert int(basic.succeed(f"grep -c sae-only {config_file}")) == 1
          assert int(basic.succeed(f"grep -c mixed-wpa {config_file}")) == 2

      # save file for manual inspection
      basic.copy_from_vm(config_file)

      with subtest("Daemon is running and accepting connections"):
          basic.wait_for_unit("wpa_supplicant-wlan1.service")
          status = basic.succeed("wpa_cli -i wlan1 status")
          assert "Failed to connect" not in status, \
                 "Failed to connect to the daemon"

      with subtest("Daemon can be configured imperatively"):
          imperative.wait_until_succeeds("wpa_cli -i wlan1 status")
          imperative.succeed("wpa_cli -i wlan1 add_network")
          imperative.succeed("wpa_cli -i wlan1 set_network 0 ssid '\"nixos-test\"'")
          imperative.succeed("wpa_cli -i wlan1 set_network 0 psk '\"reproducibility\"'")
          imperative.succeed("wpa_cli -i wlan1 save_config")
          imperative.succeed("grep -q nixos-test /etc/wpa_supplicant.conf")

      machineSae.wait_for_unit("hostapd.service")
      machineSae.copy_from_vm("/run/hostapd/wlan0.hostapd.conf")
      with subtest("Daemon can connect to the SAE access point using SAE"):
          machineSae.wait_until_succeeds(
            "wpa_cli -i wlan1 status | grep -q wpa_state=COMPLETED"
          )

      with subtest("Daemon can connect to the SAE and WPA2 mixed access point using SAE"):
          machineMixedUsingSae.wait_until_succeeds(
            "wpa_cli -i wlan1 status | grep -q wpa_state=COMPLETED"
          )

      with subtest("Daemon can connect to the SAE and WPA2 mixed access point using WPA2"):
          machineMixedUsingWpa2.wait_until_succeeds(
            "wpa_cli -i wlan1 status | grep -q wpa_state=COMPLETED"
          )

      with subtest("Daemon can connect to the WPA2 access point using WPA2"):
          machineWpa2.wait_until_succeeds(
            "wpa_cli -i wlan1 status | grep -q wpa_state=COMPLETED"
          )
    '';
})
