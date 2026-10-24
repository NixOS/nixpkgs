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
}
```

NordVPN includes a `killswitch` feature,
which blocks all packets not associated with the VPN connection.

If you choose to use your own user and group, you can do so using

```nix
{
  services.nordvpn.user = "SOME-USER";
  services.nordvpn.group = "SOME-GROUP";
}
```

Otherwise, the service creates a `nordvpn` user and group,
in which case you should add your user to the `nordvpn` group.

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

If you choose to use NordVPN's Meshnet,
you must explicitly declare the IP to peer mapping,
typically via `networking.hosts`. Example:

```nix
{
  networking.hosts = {
    "1.2.3.4" = [
      "my-alias"
      "my-nick"
    ];
  };
}
```

You can find the IP to peer mapping using the command

```bash
nordvpn mesh peer list
```

which would also list devices *not* present inside {file}`/etc/hosts`.

NordVPN provides several useful CLI commands, including:

```bash
nordvpn login  # Log in using an OAuth URL
nordvpn login --token <token>  # Log in with a token from your account
nordvpn c  # Connect to the VPN
nordvpn c ie  # Connect to a NordVPN server in Ireland
nordvpn d  # Disconnect from the VPN
nordvpn set technology openvpn  # Switch to OpenVPN technology
nordvpn c  # Reconnect after changing technology
nordvpn set mesh on  # Turn on meshnet
nordvpn mesh peer list  # List meshnet peers
nordvpn fileshare list  # List incoming/outgoing file transfers
```

Additionally, if you prefer to use the friendly GUI,

```bash
nordvpn-gui
```

Some notes on where the NixOS nordvpn service *locks down* from upstream:

- `nordvpnd` runs as an unprivileged user
- `norduserd` spawns as a user service
- `nordvpnd`'s systemd unit applies additional sandboxing,
  further minimizing its blast radius
- `nordvpnd` can only *read* {file}`/etc/hosts`

Additionally, the service:

- adds `nordlynx` to the firewall's `trustedInterfaces`

**Disclaimer:** this module does not support nordwhisper,
NordVPN's closed-source protocol,
since it requires the proprietary `quench` library.
