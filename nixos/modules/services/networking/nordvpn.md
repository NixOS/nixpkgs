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

NordVPN includes a `kill-switch` feature that blocks all packets not associated with the VPN connection.

If you prefer to use your own user and group, you can do so using

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

Meshnet and fileshare are supported:

```bash
nordvpn set meshnet on
nordvpn mesh peer list
```

`nordvpnd` never writes to `/etc/hosts`, which NixOS manages declaratively,
so peer hostnames (e.g. `some-peer.nord`) do not resolve out of the box.
Map the peers you need via `networking.hosts`, using the IPs shown by
`nordvpn mesh peer list`:

```nix
{
  networking.hosts = {
    "100.64.0.2" = [ "some-peer.nord" ];
  };
}
```

Some notes on where the NixOS nordvpn service differs from upstream:

- `nordvpnd` runs as an unprivileged user
- `norduserd` spawns as a user service
- `nordvpnd`'s systemd unit applies additional sandboxing,
further minimizing its blast radius

**Disclaimer:** the closed-source nordwhisper protocol is not supported, as
it requires NordVPN's proprietary `quench` library.
