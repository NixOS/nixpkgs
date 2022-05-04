import ./make-test-python.nix ({ pkgs, lib, ...}:
{
  name = "wpa_supplicant";
  meta = with lib.maintainers; {
    maintainers = [ rnhmjoj ];
  };

  nodes.machine = { ... }: {
    imports = [ ../modules/profiles/minimal.nix ];

    # add a virtual wlan interface
    boot.kernelModules = [ "mac80211_hwsim" ];

    # wireless access point
    services.hostapd = {
      enable = true;
      wpa = true;
      interface = "wlan0";
      ssid = "nixos-test";
      wpaPassphrase = "reproducibility";
    };

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

        # test network
        nixos-test.psk = "@PSK_NIXOS_TEST@";

        # secrets substitution test cases
        test1.psk = "@PSK_VALID@";              # should be replaced
        test2.psk = "@PSK_SPECIAL@";            # should be replaced
        test3.psk = "@PSK_MISSING@";            # should not be replaced
        test4.psk = "P@ssowrdWithSome@tSymbol"; # should not be replaced
      };

      # secrets
      environmentFile = pkgs.writeText "wpa-secrets" ''
        PSK_NIXOS_TEST="reproducibility"
        PSK_VALID="S0m3BadP4ssw0rd";
        # taken from https://github.com/minimaxir/big-list-of-naughty-strings
        PSK_SPECIAL=",./;'[]\-= <>?:\"{}|_+ !@#$%^\&*()`~";
      '';
    };

  };

  testScript =
    ''
      config_file = "/run/wpa_supplicant/wpa_supplicant.conf"

      with subtest("Configuration file is inaccessible to other users"):
          machine.wait_for_file(config_file)
          machine.fail(f"sudo -u nobody ls {config_file}")

      with subtest("Secrets variables have been substituted"):
          machine.fail(f"grep -q @PSK_VALID@ {config_file}")
          machine.fail(f"grep -q @PSK_SPECIAL@ {config_file}")
          machine.succeed(f"grep -q @PSK_MISSING@ {config_file}")
          machine.succeed(f"grep -q P@ssowrdWithSome@tSymbol {config_file}")

      with subtest("WPA2 fallbacks have been generated"):
          assert int(machine.succeed(f"grep -c sae-only {config_file}")) == 1
          assert int(machine.succeed(f"grep -c mixed-wpa {config_file}")) == 2

      # save file for manual inspection
      machine.copy_from_vm(config_file)

      with subtest("Daemon is running and accepting connections"):
          machine.wait_for_unit("wpa_supplicant-wlan1.service")
          status = machine.succeed("wpa_cli -i wlan1 status")
          assert "Failed to connect" not in status, \
                 "Failed to connect to the daemon"

      with subtest("Daemon can connect to the access point"):
          machine.wait_until_succeeds(
            "wpa_cli -i wlan1 status | grep -q wpa_state=COMPLETED"
          )
    '';
})
