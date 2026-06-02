{ pkgs, lib, ... }:

let
  ssid = "Hydra SmokeNet";
  psk = "stayoffmywifi";
  wlanInterface = "wlan0";
in
{
  name = "kismet";

  nodes =
    let
      hostAddress = id: "192.168.1.${toString (id + 1)}";
      serverAddress = hostAddress 1;
    in
    {
      airgap =
        { config, ... }:
        {
          networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
            {
              address = serverAddress;
              prefixLength = 24;
            }
          ];
          services.vwifi = {
            server = {
              enable = true;
              ports.tcp = 8212;
              ports.spy = 8213;
              openFirewall = true;
            };
          };
        };

      ap =
        { config, ... }:
        {
          networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
            {
              address = hostAddress 2;
              prefixLength = 24;
            }
          ];
          services.hostapd = {
            enable = true;
            radios.${wlanInterface} = {
              channel = 1;
              networks.${wlanInterface} = {
                inherit ssid;
                authentication = {
                  mode = "wpa3-sae";
                  saePasswords = [ { password = psk; } ];
                  enableRecommendedPairwiseCiphers = true;
                };
              };
            };
          };
          services.vwifi = {
            module = {
              enable = true;
              macPrefix = "74:F8:F6:00:01";
            };
            client = {
              enable = true;
              inherit serverAddress;
            };
          };
        };

      station =
        { config, pkgs, ... }:
        {
          networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
            {
              address = hostAddress 3;
              prefixLength = 24;
            }
          ];
          networking.wireless = {
            # No, really, we want it enabled!
            enable = lib.mkOverride 0 true;
            interfaces = [ wlanInterface ];
            networks = {
              ${ssid} = {
                inherit psk;
                authProtocols = [ "SAE" ];
              };
            };
          };
          services.vwifi = {
            module = {
              enable = true;
              macPrefix = "74:F8:F6:00:02";
            };
            client = {
              enable = true;
              inherit serverAddress;
            };
          };
          environment.systemPackages = [ pkgs.nettools ];
        };

      monitor =
        { config, pkgs, ... }:
        {
          networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
            {
              address = hostAddress 4;
              prefixLength = 24;
            }
          ];

          services.kismet = {
            enable = true;
            serverName = "NixOS Kismet Smoke Test";
            serverDescription = "Server testing virtual wifi devices running on Hydra";
            httpd.enable = true;
            # Check that the settings all eval correctly
            settings = {
              # Should append to log_types
              log_types' = "wiglecsv";

              # Should all generate correctly
              wepkey = [
                "00:DE:AD:C0:DE:00"
                "FEEDFACE42"
              ];
              alert = [
                [
                  "ADHOCCONFLICT"
                  "5/min"
                  "1/sec"
                ]
                [
                  "ADVCRYPTCHANGE"
                  "5/min"
                  "1/sec"
                ]
              ];
              gps.gpsd = {
                host = "localhost";
                port = 2947;
              };
              apspoof.Foo1 = [
                {
                  ssid = "Bar1";
                  validmacs = [
                    "00:11:22:33:44:55"
                    "aa:bb:cc:dd:ee:ff"
                  ];
                }
                {
                  ssid = "Bar2";
                  validmacs = [
                    "01:12:23:34:45:56"
                    "ab:bc:cd:de:ef:f0"
                  ];
                }
              ];
              apspoof.Foo2 = [
                {
                  ssid = "Bar2";
                  validmacs = [
                    "00:11:22:33:44:55"
                    "aa:bb:cc:dd:ee:ff"
                  ];
                }
              ];

              # The actual source
              source.${wlanInterface} = {
                name = "Virtual Wifi";
              };
            };
            extraConfig = ''
              # this comment should be ignored
            '';
          };

          services.vwifi = {
            module = {
              enable = true;
              macPrefix = "74:F8:F6:00:03";
            };
            client = {
              enable = true;
              spy = true;
              inherit serverAddress;
            };
          };

          environment.systemPackages = [
            config.services.kismet.package
            config.services.vwifi.package
            pkgs.jq
          ];
        };
    };

  testScript =
    { nodes, ... }:
    ''
      import shlex

      # Wait for the vwifi server to come up
      airgap.start()
      airgap.wait_for_unit("vwifi-server.service")
      airgap.wait_for_open_port(${toString nodes.airgap.services.vwifi.server.ports.tcp})

      httpd_port = ${toString nodes.monitor.services.kismet.httpd.port}
      server_name = "${nodes.monitor.services.kismet.serverName}"
      server_description = "${nodes.monitor.services.kismet.serverDescription}"
      wlan_interface = "${wlanInterface}"
      ap_essid = "${ssid}"
      ap_mac_prefix = "${nodes.ap.services.vwifi.module.macPrefix}"
      station_mac_prefix = "${nodes.station.services.vwifi.module.macPrefix}"

      # Spawn the other nodes.
      monitor.start()

      # Wait for the monitor to come up
      monitor.wait_for_unit("kismet.service")
      monitor.wait_for_open_port(httpd_port)

      # Should be up but require authentication.
      url = f"http://localhost:{httpd_port}"
      monitor.succeed(f"curl {url} | tee /dev/stderr | grep '<title>Kismet</title>'")

      # Have to set the password now.
      monitor.succeed("echo httpd_username=nixos >> ~kismet/.kismet/kismet_httpd.conf")
      monitor.succeed("echo httpd_password=hydra >> ~kismet/.kismet/kismet_httpd.conf")
      monitor.systemctl("restart kismet.service")
      monitor.wait_for_unit("kismet.service")
      monitor.wait_for_open_port(httpd_port)

      # Authentication should now work.
      url = f"http://nixos:hydra@localhost:{httpd_port}"
      monitor.succeed(f"curl {url}/system/status.json | tee /dev/stderr | jq -e --arg serverName {shlex.quote(server_name)} --arg serverDescription {shlex.quote(server_description)} '.\"kismet.system.server_name\" == $serverName and .\"kismet.system.server_description\" == $serverDescription'")

      # Wait for the station to connect to the AP while Kismet is monitoring
      ap.start()
      station.start()

      unit = f"wpa_supplicant-{wlan_interface}"

      # Generate handshakes until we detect both devices
      success = False
      for i in range(100):
        station.wait_for_unit(f"wpa_supplicant-{wlan_interface}.service")
        station.succeed(f"ifconfig {wlan_interface} down && ifconfig {wlan_interface} up")
        station.wait_until_succeeds(f"journalctl -u {shlex.quote(unit)} -e | grep -Eqi {shlex.quote(wlan_interface + ': CTRL-EVENT-CONNECTED - Connection to ' + ap_mac_prefix + '[0-9a-f:]* completed')}")
        station.succeed(f"journalctl --rotate --unit={shlex.quote(unit)}")
        station.succeed(f"sleep 3 && journalctl --vacuum-time=1s --unit={shlex.quote(unit)}")

        # We're connected, make sure Kismet sees both of our devices
        status, stdout = monitor.execute(f"curl {url}/devices/views/all/last-time/0/devices.json | tee /dev/stderr | jq -e --arg macPrefix {shlex.quote(ap_mac_prefix)} --arg ssid {shlex.quote(ap_essid)} '. | (map(select((.\"kismet.device.base.macaddr\"? | startswith($macPrefix)) and .\"dot11.device\"?.\"dot11.device.last_beaconed_ssid_record\"?.\"dot11.advertisedssid.ssid\" == $ssid)) | length) == 1'")
        if status != 0:
          continue
        status, stdout = monitor.execute(f"curl {url}/devices/views/all/last-time/0/devices.json | tee /dev/stderr | jq -e --arg macPrefix {shlex.quote(station_mac_prefix)} '. | (map(select((.\"kismet.device.base.macaddr\"? | startswith($macPrefix)))) | length) == 1'")
        if status == 0:
          success = True
          break

      assert success
    '';
}
