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
        environmentFile = pkgs.writeText "wpa-secrets" ''
          PSK_NIXOS_TEST="reproducibility"
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

          # secrets substitution test cases
          test1.psk = "@PSK_VALID@";              # should be replaced
          test2.psk = "@PSK_SPECIAL@";            # should be replaced
          test3.psk = "@PSK_MISSING@";            # should not be replaced
          test4.psk = "P@ssowrdWithSome@tSymbol"; # should not be replaced
        };

        # secrets
        environmentFile = pkgs.writeText "wpa-secrets" ''
          PSK_VALID="S0m3BadP4ssw0rd";
          # taken from https://github.com/minimaxir/big-list-of-naughty-strings
          PSK_SPECIAL=",./;'[]\-= <>?:\"{}|_+ !@#$%^\&*()`~";
        '';
      };
    };

    # Test connecting to the SAE-only hotspot using SAE
    machineSae = machineWithHostapd {
      networking.wireless = {
        fallbackToWPA2 = false;
        networks.nixos-test-sae = {
          psk = "@PSK_NIXOS_TEST@";
          authProtocols = [ "SAE" ];
        };
      };
    };

    # Test connecting to the SAE and WPA2 mixed hotspot using SAE
    machineMixedUsingSae = machineWithHostapd {
      networking.wireless = {
        fallbackToWPA2 = false;
        networks.nixos-test-mixed = {
          psk = "@PSK_NIXOS_TEST@";
          authProtocols = [ "SAE" ];
        };
      };
    };

    # Test connecting to the SAE and WPA2 mixed hotspot using WPA2
    machineMixedUsingWpa2 = machineWithHostapd {
      networking.wireless = {
        fallbackToWPA2 = true;
        networks.nixos-test-mixed = {
          psk = "@PSK_NIXOS_TEST@";
          authProtocols = [ "WPA-PSK-SHA256" ];
        };
      };
    };

    # Test connecting to the WPA2 legacy hotspot using WPA2
    machineWpa2 = machineWithHostapd {
      networking.wireless = {
        fallbackToWPA2 = true;
        networks.nixos-test-wpa2 = {
          psk = "@PSK_NIXOS_TEST@";
          authProtocols = [ "WPA-PSK-SHA256" ];
        };
      };
    };
  };

  testScript =
    ''
      config_file = "/run/wpa_supplicant/wpa_supplicant.conf"

      with subtest("Configuration file is inaccessible to other users"):
          basic.wait_for_file(config_file)
          basic.fail(f"sudo -u nobody ls {config_file}")

      with subtest("Secrets variables have been substituted"):
          basic.fail(f"grep -q @PSK_VALID@ {config_file}")
          basic.fail(f"grep -q @PSK_SPECIAL@ {config_file}")
          basic.succeed(f"grep -q @PSK_MISSING@ {config_file}")
          basic.succeed(f"grep -q P@ssowrdWithSome@tSymbol {config_file}")

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
