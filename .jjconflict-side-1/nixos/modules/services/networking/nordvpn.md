# NordVPN {#module-services-nordvpn}

*Source:* {file}`modules/services/networking/nordvpn.nix`

*Upstream documentation:* <https://github.com/NordSecurity/nordvpn-linux>

NordVPN offers a paid virtual private network (VPN) service.
The service operates as closed-source,
but the Linux client uses open-source code licensed under GPLv3.
A minimal configuration in NixOS appears as follows:

```nix
{
  services.nordvpn.enable = true;
  networking.firewall.enable = true;
  networking.firewall.checkReversePath = "loose";
}
```

When using a firewall, set `networking.firewall.checkReversePath` to `"loose"` or `false`.
NordVPN includes a `kill-switch` feature that blocks all packets not associated with the VPN connection.

Additionally, add your user to the `nordvpn` group.

```nix
{
  users.users.yourUser = {
    #..
    extraGroups = [
      #..
      "nordvpn"
    ];
  };
}
```

If you prefer to use your own user and group, you can do so using

```nix
{
  services.nordvpn.user = "SOME-USER";
  services.nordvpn.group = "SOME-GROUP";
}
```

NordVPN provides several useful CLI commands, including:

```bash
nordvpn login  # Log in using an OAuth URL
nordvpn login --token <token>  # Log in with a token obtained from your NordVPN account
nordvpn c  # Connect to the VPN
nordvpn c ie  # Connect to a NordVPN server in Ireland
nordvpn d  # Disconnect from the VPN
nordvpn set technology openvpn  # Switch to OpenVPN technology
nordvpn c  # Reconnect after changing technology
```

Additionally, if you prefer to use the friendly GUI,

```bash
nordvpn-gui
```

**Disclaimer:** NixOS currently does not support meshnet.
Contributions welcome!
