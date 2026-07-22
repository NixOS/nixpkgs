# Wireless Networks {#sec-wireless}

For a desktop installation using NetworkManager (e.g., GNOME or KDE), you should
make sure the user is in the `networkmanager` group and you can just configure
wireless networks from the Settings app.
It is also possible to declare (some) wireless networks from the NixOS
configuration with [](#opt-networking.networkmanager.ensureProfiles.profiles).

Alternatively, without NetworkManager, you can configure wireless networks
using wpa_supplicant by setting

```nix
{ networking.wireless.enable = true; }
```

By default, wpa_supplicant will manage the first wireless interface that becomes
available. It is however recommended to set the desired interface name with
[](#opt-networking.wireless.interfaces), as it is more reliable.

If multiple interfaces are set, NixOS will create a separate systemd service
for each one of them, for example:

```nix
{
  networking.wireless.interfaces = [
    "wlan0"
    "wlan1"
  ];
}
```

results in `wpa_supplicant-wlan0.service` and `wpa_supplicant-wlan1.service`.


## Declarative configuration {#sec-wireless-declarative}

NixOS lets you specify networks declaratively:

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

If the network is using WPA2, the pre-shared key (PSK) can be also specified
with the `pskRaw` option as 64 hexadecimal digits.
This is useful to both obfuscate passwords and make the connection slightly
faster, as the key doesn't need to be derived every time.

The `pskRaw` values can be calculated using the `wpa_passphrase` tool:

```console
$ wpa_passphrase ESSID PSK
network={
        ssid="echelon"
        #psk="abcdefgh"
        psk=dca6d6ed41f4ab5a984c9f55f6f66d4efdc720ebf66959810f4329bb391c5435
}
```

```nix
{
  networking.wireless.networks.echelon = {
    pskRaw = "dca6d6ed41f4ab5a984c9f55f6f66d4efdc720ebf66959810f4329bb391c5435";
  };
}
```

Other wpa_supplicant configuration can be set using the {option}`extraConfig`
option, either globally or per-network. For example:
```
{
  networking.wireless.extraConfig = ''
    # Enable MAC address randomization by default
    mac_addr=1
  '';
  networking.wireless.networks.home = {
    psk = "abcdefgh";
    extraConfig = ''
      # Use the real MAC address at home
      mac_addr=0
    '';
  };
}
```

::: {.note}
The generated wpa_supplicant configuration file is linked to
`/etc/wpa_supplicant/nixos.conf` for easier inspection.
:::


Be aware that in the previous examples the keys would be written to the Nix
store in plain text and readable to every local user.
It is recommended to specify secrets (PSKs, passwords, etc.) in a safe way using
[](#opt-networking.wireless.secretsFile) and the `ext:` syntax. For example:

```nix
{
  networking.wireless.secretsFile = "/run/secrets/wireless.conf";
  networking.wireless.networks = {
    home = {
      pskRaw = "ext:psk_home";
    };
    work.auth = ''
      eap=PEAP
      identity="my-user@example.com"
      password=ext:pass_work
    '';
  };
}
```

where `/run/secrets/wireless.conf` contains

```
psk_home=mypassword
pass_work=myworkpassword
```

::: {.note}
The secrets file should be owned and placed in a location accessible (only) by
the `wpa_supplicant` user. Only certain fields support the `ext:` syntax,
for example `psk`, `sae_password` and `password`, but not `ssid`.
:::


## Imperative configuration  {#sec-wireless-imperative}

It can be useful to add a new network without rebuilding the NixOS
configuration, particularly if you don't yet have Internet access.
Setting [](#opt-networking.wireless.userControlled) to `true` will allow users
of the `wpa_supplicant` group to configure wpa_supplicant imperatively.

For example, using `wpa_cli` you can add a new network and connect to it as:
```console
# wpa_cli
Selected interface 'wlan0'

Interactive mode

> add_network
10
> set_network 10 ssid "echelon"
OK
> set_network 10 psk "abcdefgh"
OK
> select_network 10
OK
```

Note that these changes will be lost when wpa_supplicant is restarted.
To make them persistent, the option
[](#opt-networking.wireless.allowAuxiliaryImperativeNetworks) can be set, which
allows to use the `save` command in `wpa_cli`, or even directly editing the
file `/etc/wpa_supplicant/imperative.conf`.

::: {.note}
Remember that after manually editing `imperative.conf` the wpa_supplicant daemon
needs to be restarted:
```console
# systemctl restart wpa_supplicant.service
```
or
```console
# systemctl restart wpa_supplicant-<interface>.service
```
if [](#opt-networking.wireless.interfaces) has been set.
:::


## Enterprise networks {#sec-wireless-enterprise}

Networks with more sophisticated authentication protocols can be configured
using the free-form `auth` option, for example:

```
{
  networking.wireless.networks = {
    eduroam.auth = ''
      key_mgmt=WPA-EAP
      eap=PEAP
      identity="alice.smith@example.com"
      password="veryLongPassword$!3"
      ca_cert="/etc/wpa_supplicant/eduroam.pem"
    '';
  };
}
```

For examples and a list of available options, see the
[wpa_supplicant.conf(5)](man:wpa_supplicant.conf(5)) man page.

::: {.warning}
By default, security hardening measures that limit access to files, devices and
network capabilities are applied to the wpa_supplicant daemon.

Certificates and other files supplied here need to be readable by the
`wpa_supplicant` user; it is therefore recommended to store them in the
`/etc/wpa_supplicant` directory.

If your network authentication protocol requires write access to files, smart
cards or TPM devices, you may have to disable security hardening with
```nix
{ networking.wireless.enableHardening = false; }
```

This setting also applies to networks configured from NetworkManager, unless
the WiFi [backend](#opt-networking.networkmanager.wifi.backend) in use is not
wpa_supplicant.
:::
