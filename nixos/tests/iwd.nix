{ lib, ... }:

let
  # Every character that needs care in a config file, as in the
  # wpa_supplicant test.
  naughtyPassphrase = ''!,./;'[]\-=<>?:"{}|_+@$%^&*()`~ # ceci n'est pas un commentaire'';

  # Not only alphanumerics, so iwd stores the network under its hex-encoded SSID.
  ssid = "nixos-tést";
in
{
  name = "iwd";

  nodes.machine =
    { pkgs, ... }:
    {
      # Two simulated radios: wlan0 serves the access point, wlan1 is iwd's.
      boot.kernelModules = [ "mac80211_hwsim" ];

      services.hostapd = {
        enable = true;
        radios.wlan0 = {
          band = "2g";
          channel = 6;
          countryCode = "US";
          networks.wlan0 = {
            inherit ssid;
            authentication = {
              mode = "wpa2-sha256";
              wpaPassword = naughtyPassphrase;
            };
          };
        };
      };

      networking.wireless.iwd = {
        enable = true;
        # Use wlan1 as it is rather than recreating it.
        settings.DriverQuirks.DefaultInterface = "*";
        knownNetworks.${ssid}.Security.Passphrase._secret = "/var/lib/secrets/wifi";
      };
      # Leave the access point's radio to hostapd.
      systemd.services.iwd.serviceConfig.ExecStart = [
        ""
        "${pkgs.iwd}/libexec/iwd --nophys phy0"
      ];

      # The secret lives outside the Nix store, as a real one would.
      systemd.services.wifi-secret = {
        wantedBy = [ "iwd.service" ];
        before = [ "iwd.service" ];
        serviceConfig.Type = "oneshot";
        script = ''
          install -Dm600 ${pkgs.writeText "wifi" naughtyPassphrase} /var/lib/secrets/wifi
        '';
      };

      specialisation.forgotten.configuration = {
        networking.wireless.iwd.knownNetworks = lib.mkForce { };
      };
    };

  testScript = ''
    network_file = "/var/lib/iwd/=" + "${ssid}".encode().hex() + ".psk"

    machine.wait_for_unit("hostapd.service")
    machine.wait_for_unit("iwd.service")

    with subtest("The declared network is written with its secret filled in"):
        machine.succeed(f"test -f '{network_file}'")
        machine.fail(f"grep -q '@secret-' '{network_file}'")

    with subtest("iwd joins the network with the passphrase from the secret file"):
        machine.wait_until_succeeds("iwctl station wlan1 show | grep -E 'State +connected'")

    with subtest("A network added at runtime stays when the declared one is removed"):
        machine.succeed("printf '[Security]\\nPassphrase=12345678\\n' > /var/lib/iwd/runtime.psk")
        machine.succeed("/run/current-system/specialisation/forgotten/bin/switch-to-configuration test")
        machine.wait_until_succeeds(f"test ! -e '{network_file}'")
        machine.succeed("test -f /var/lib/iwd/runtime.psk")
  '';
}
