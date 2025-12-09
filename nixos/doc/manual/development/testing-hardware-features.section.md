# Testing Hardware Features {#sec-nixos-test-testing-hardware-features}

This section covers how to test various features using NixOS tests that would
normally only be possible with hardware. It is designed to showcase the NixOS test
framework's flexibility when combined with various hardware simulation libraries
or kernel modules.

## Wi-Fi {#sec-nixos-test-wifi}

Use `services.vwifi` to set up a virtual Wi-Fi physical layer. Create at least two nodes
for this kind of test: one with vwifi active, and either a station or an access point.
Give each a static IP address on the test network so they will never collide.
This module likely supports other topologies too; document them if you make one.

This NixOS module leverages [vwifi](https://github.com/Raizo62/vwifi). Read the
upstream repository's documentation for more information.

### vwifi server {#sec-nixos-test-wifi-vwifi-server}

This node runs the vwifi server, and otherwise does not interact with the network.
You can run `vwifi-ctrl` on this node to control characteristics of the simulated
physical layer.

```nix
{
  airgap =
    { config, ... }:
    {
      networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
        {
          address = "192.168.1.2";
          prefixLength = 24;
        }
      ];
      services.vwifi = {
        server = {
          enable = true;
          ports.tcp = 8212;
          # uncomment if you want to enable monitor mode on another node
          # ports.spy = 8213;
          openFirewall = true;
        };
      };
    };
}
```

### AP {#sec-nixos-test-wifi-ap}

A node like this will act as a wireless access point in infrastructure mode.

```nix
{
  ap =
    { config, ... }:
    {
      networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
        {
          address = "192.168.1.3";
          prefixLength = 24;
        }
      ];
      services.hostapd = {
        enable = true;
        radios.wlan0 = {
          channel = 1;
          networks.wlan0 = {
            ssid = "NixOS Test Wi-Fi Network";
            authentication = {
              mode = "wpa3-sae";
              saePasswords = [ { password = "supersecret"; } ];
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
          serverAddress = "192.168.1.2";
        };
      };
    };
}
```

### Station {#sec-nixos-test-wifi-station}

A node like this acts as a wireless client.

```nix
{
  station =
    { config, ... }:
    {
      networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
        {
          address = "192.168.1.3";
          prefixLength = 24;
        }
      ];
      networking.wireless = {
        # No, really, we want it enabled!
        enable = lib.mkOverride 0 true;
        interfaces = [ "wlan0" ];
        networks = {
          "NixOS Test Wi-Fi Network" = {
            psk = "supersecret";
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
          serverAddress = "192.168.1.2";
        };
      };
    };
}
```

### Monitor {#sec-nixos-test-wifi-monitor}

When the monitor mode interface is enabled, this node will receive
all packets broadcast by all other nodes through the spy interface.

```nix
{
  monitor =
    { config, ... }:
    {
      networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
        {
          address = "192.168.1.4";
          prefixLength = 24;
        }
      ];

      services.vwifi = {
        module = {
          enable = true;
          macPrefix = "74:F8:F6:00:03";
        };
        client = {
          enable = true;
          spy = true;
          serverAddress = "192.168.1.2";
        };
      };
    };
}
```
