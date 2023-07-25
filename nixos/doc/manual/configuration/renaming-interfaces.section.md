# Renaming network interfaces {#sec-rename-ifs}

NixOS uses the udev [predictable naming
scheme](https://systemd.io/PREDICTABLE_INTERFACE_NAMES/) to assign names
to network interfaces. This means that by default cards are not given
the traditional names like `eth0` or `eth1`, whose order can change
unpredictably across reboots. Instead, relying on physical locations and
firmware information, the scheme produces names like `ens1`, `enp2s0`,
etc.

These names are predictable but less memorable and not necessarily
stable: for example installing new hardware or changing firmware
settings can result in a [name
change](https://github.com/systemd/systemd/issues/3715#issue-165347602).
If this is undesirable, for example if you have a single ethernet card,
you can revert to the traditional scheme by setting
[](#opt-networking.usePredictableInterfaceNames)
to `false`.

## Assigning custom names {#sec-custom-ifnames}

In case there are multiple interfaces of the same type, it's better to
assign custom names based on the device hardware address. For example,
we assign the name `wan` to the interface with MAC address
`52:54:00:12:01:01` using a netword link unit:

```nix
systemd.network.links."10-wan" = {
  matchConfig.PermanentMACAddress = "52:54:00:12:01:01";
  linkConfig.Name = "wan";
};
```

Note that links are directly read by udev, *not networkd*, and will work
even if networkd is disabled.

Alternatively, we can use a plain old udev rule:

```nix
boot.initrd.services.udev.rules = ''
  SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", \
  ATTR{address}=="52:54:00:12:01:01", KERNEL=="eth*", NAME="wan"
'';
```

::: {.warning}
The rule must be installed in the initrd using
`boot.initrd.services.udev.rules`, not the usual `services.udev.extraRules`
option. This is to avoid race conditions with other programs controlling
the interface.
:::
