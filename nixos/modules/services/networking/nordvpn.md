# NordVPN {#module-services-nordvpn}

*Source:* {file}`modules/services/networking/nordvpn.nix`

*Upstream documentation:* <https://github.com/NordSecurity/nordvpn-linux>

NordVPN is a paid virtual private network (VPN) service.
While the service itself is closed-source, the Linux client is open-source and
licensed under the GNU General Public License version 3 (GPLv3). A minimal
configuration in NixOS looks like this:

```nix
{
  services.nordvpn.enable = true;
  networking.firewall.enable = true;
  networking.firewall.checkReversePath = "loose";
}
```

Note that if you're using firewall then
`networking.firewall.checkReversePath` can either be `"loose"` or `false`.
NordVPN provides a `kill-switch` feature that drops all packets not associated
with the VPN connection.

Additionally, add your user to the `nordvpn` group.

```nix
users.users.YOUR-USER = {
    ...
    extraGroups = [
      ...
      "nordvpn"
    ];
};
```

If you prefer to use your own user and group, you can do so using

```nix
services.nordvpn.user = USER;
services.nordvpn.group = GROUP;
```

Here are some helpful nordvpn cli commands

```bash
nordvpn login  # Log in using an OAuth URL
nordvpn login --token <token>  # Log in with a token obtained from your NordVPN account
nordvpn c  # Connect to the VPN
nordvpn c ie  # Connect to a NordVPN server in Ireland
nordvpn d  # Disconnect from the VPN
nordvpn set technology openvpn  # Switch to OpenVPN technology
nordvpn c  # Reconnect after changing technology
```

**Disclaimer:** Currently meshnet is not supported on NixOS.

Contributions are welcome!
