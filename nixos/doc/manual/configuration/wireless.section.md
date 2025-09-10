# Wireless Networks {#sec-wireless}

For a desktop installation using NetworkManager (e.g., GNOME), you just
have to make sure the user is in the `networkmanager` group and you can
skip the rest of this section on wireless networks.

NixOS will start wpa_supplicant for you if you enable this setting:

```nix
{ networking.wireless.enable = true; }
```

NixOS lets you specify networks for wpa_supplicant declaratively:

```nix
{
  networking.wireless.networks = {
    # SSID with no spaces or special characters
    echelon = {
      psk = "abcdefgh";
    };
    # SSID with spaces and/or special characters
    "echelon's AP" = {
      psk = "ijklmnop";
    };
    # Hidden SSID
    echelon = {
      hidden = true;
      psk = "qrstuvwx";
    };
    free.wifi = { }; # Public wireless network
  };
}
```

Be aware that keys will be written to the nix store in plaintext! When
no networks are set, it will default to using a configuration file at
`/etc/wpa_supplicant.conf`. You should edit this file yourself to define
wireless networks, WPA keys and so on (see wpa_supplicant.conf(5)).

If you are using WPA2 you can generate pskRaw key using
`wpa_passphrase`:

```ShellSession
$ wpa_passphrase ESSID PSK
network={
        ssid="echelon"
        #psk="abcdefgh"
        psk=dca6d6ed41f4ab5a984c9f55f6f66d4efdc720ebf66959810f4329bb391c5435
}
```

```nix
{
  networking.wireless.networks = {
    echelon = {
      pskRaw = "dca6d6ed41f4ab5a984c9f55f6f66d4efdc720ebf66959810f4329bb391c5435";
    };
  };
}
```

or you can use it to directly generate the `wpa_supplicant.conf`:

```ShellSession
# wpa_passphrase ESSID PSK > /etc/wpa_supplicant.conf
```

After you have edited the `wpa_supplicant.conf`, you need to restart the
wpa_supplicant service.

```ShellSession
# systemctl restart wpa_supplicant.service
```
