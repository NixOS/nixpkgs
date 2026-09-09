# NetworkManager {#sec-networkmanager}

To facilitate network configuration, some desktop environments use
NetworkManager. You can enable NetworkManager by setting:

```nix
{ networking.networkmanager.enable = true; }
```

some desktop managers (e.g., GNOME) enable NetworkManager automatically
for you.

All users that should have permission to change network settings must
belong to the `networkmanager` group:

```nix
{ users.users.alice.extraGroups = [ "networkmanager" ]; }
```

NetworkManager is controlled using either `nmcli` or `nmtui`
(curses-based terminal user interface). See their manual pages for
details on their usage. Some desktop environments (GNOME, KDE) have
their own configuration tools for NetworkManager. On XFCE, there is no
configuration tool for NetworkManager by default: by enabling
[](#opt-programs.nm-applet.enable), the graphical applet will be
installed and will launch automatically when the graphical session is
started.

::: {.note}
`networking.networkmanager` and `networking.wireless` (WPA Supplicant)
can be used together if desired. To do this you need to instruct
NetworkManager to ignore those interfaces like:

```nix
{
  networking.networkmanager.unmanaged = [
    "*"
    "except:type:wwan"
    "except:type:gsm"
  ];
}
```

Refer to the option description for the exact syntax and references to
external documentation.
:::
