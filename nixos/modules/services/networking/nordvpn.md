# NordVPN {#module-services-nordvpn}

*Source:* {file}`modules/services/networking/nordvpn.nix`

*Upstream documentation:* <https://github.com/NordSecurity/nordvpn-linux>

```nix
{
  services.nordvpn.enable = true;
  networking.firewall.enable = true;
}
```

NordVPN offers a paid virtual private network (VPN) service.
The service operates as closed-source,
but the Linux client uses open-source code licensed under GPLv3.

NordVPN includes a `killswitch` feature,
which blocks all packets not associated with the VPN connection.

To use your own user and group:

```nix
{
  services.nordvpn.user = "SOME-USER";
  services.nordvpn.group = "SOME-GROUP";
}
```

Otherwise, the service creates a `nordvpn` user and group,
in which case add your user to the `nordvpn` group.

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

NordVPN provides several CLI commands, including:

```bash
nordvpn login  # Log in using an OAuth URL
nordvpn login --token <token>  # Log in with a token from your account
nordvpn c  # Connect to the VPN
nordvpn c ie  # Connect to a NordVPN server in Ireland
nordvpn d  # Disconnect from the VPN
nordvpn set protocol openvpn_tcp  # Switch to OpenVPN protocol
nordvpn c  # Reconnect after changing protocol
```

Additionally, if you prefer to use the GUI,

```bash
nordvpn-gui
```

The NixOS nordvpn service includes the following security improvements:

- `nordvpnd` runs as an unprivileged user
- `norduserd` spawns as a user service
- `nordvpnd`'s systemd unit applies additional sandboxing,
further minimizing its blast radius

**Disclaimer:** NixOS does not support meshnet.
Contributions welcome!
