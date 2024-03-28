# Upgrading NixOS {#sec-upgrading}

The best way to keep your NixOS installation up to date is to use one of
the NixOS *channels*. A channel is a Nix mechanism for distributing Nix
expressions and associated binaries. The NixOS channels are updated
automatically from NixOS's Git repository after certain tests have
passed and all packages have been built. These channels are:

-   *Stable channels*, such as [`nixos-23.11`](https://channels.nixos.org/nixos-23.11).
    These only get conservative bug fixes and package upgrades. For
    instance, a channel update may cause the Linux kernel on your system
    to be upgraded from 4.19.34 to 4.19.38 (a minor bug fix), but not
    from 4.19.x to 4.20.x (a major change that has the potential to break things).
    Stable channels are generally maintained until the next stable
    branch is created.

-   The *unstable channel*, [`nixos-unstable`](https://channels.nixos.org/nixos-unstable).
    This corresponds to NixOS's main development branch, and may thus see
    radical changes between channel updates. It's not recommended for
    production systems.

-   *Small channels*, such as [`nixos-23.11-small`](https://channels.nixos.org/nixos-23.11-small)
    or [`nixos-unstable-small`](https://channels.nixos.org/nixos-unstable-small).
    These are identical to the stable and unstable channels described above,
    except that they contain fewer binary packages. This means they get updated
    faster than the regular channels (for instance, when a critical security patch
    is committed to NixOS's source tree), but may require more packages to be
    built from source than usual. They're mostly intended for server environments
    and as such contain few GUI applications.

To see what channels are available, go to <https://channels.nixos.org>.
(Note that the URIs of the various channels redirect to a directory that
contains the channel's latest version and includes ISO images and
VirtualBox appliances.) Please note that during the release process,
channels that are not yet released will be present here as well. See the
Getting NixOS page <https://nixos.org/nixos/download.html> to find the
newest supported stable release.

When you first install NixOS, you're automatically subscribed to the
NixOS channel that corresponds to your installation source. For
instance, if you installed from a 23.11 ISO, you will be subscribed to
the `nixos-23.11` channel. To see which NixOS channel you're subscribed
to, run the following as root:

```ShellSession
# nix-channel --list | grep nixos
nixos https://channels.nixos.org/nixos-unstable
```

To switch to a different NixOS channel, do

```ShellSession
# nix-channel --add https://channels.nixos.org/channel-name nixos
```

(Be sure to include the `nixos` parameter at the end.) For instance, to
use the NixOS 23.11 stable channel:

```ShellSession
# nix-channel --add https://channels.nixos.org/nixos-23.11 nixos
```

If you have a server, you may want to use the "small" channel instead:

```ShellSession
# nix-channel --add https://channels.nixos.org/nixos-23.11-small nixos
```

And if you want to live on the bleeding edge:

```ShellSession
# nix-channel --add https://channels.nixos.org/nixos-unstable nixos
```

You can then upgrade NixOS to the latest version in your chosen channel
by running

```ShellSession
# nixos-rebuild switch --upgrade
```

which is equivalent to the more verbose `nix-channel --update nixos; nixos-rebuild switch`.

::: {.note}
Channels are set per user. This means that running `nix-channel --add`
as a non root user (or without sudo) will not affect
configuration in `/etc/nixos/configuration.nix`
:::

::: {.warning}
It is generally safe to switch back and forth between channels. The only
exception is that a newer NixOS may also have a newer Nix version, which
may involve an upgrade of Nix's database schema. This cannot be undone
easily, so in that case you will not be able to go back to your original
channel.
:::

## Automatic Upgrades {#sec-upgrading-automatic}

You can keep a NixOS system up-to-date automatically by adding the
following to `configuration.nix`:

```nix
{
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
}
```

This enables a periodically executed systemd service named
`nixos-upgrade.service`. If the `allowReboot` option is `false`, it runs
`nixos-rebuild switch --upgrade` to upgrade NixOS to the latest version
in the current channel. (To see when the service runs, see `systemctl list-timers`.)
If `allowReboot` is `true`, then the system will automatically reboot if
the new generation contains a different kernel, initrd or kernel
modules. You can also specify a channel explicitly, e.g.

```nix
{
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.11";
}
```
