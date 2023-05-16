# Upgrading NixOS {#sec-upgrading}

The best way to keep your NixOS installation up to date is to use one of
the NixOS *channels*. A channel is a Nix mechanism for distributing Nix
expressions and associated binaries. The NixOS channels are updated
automatically from NixOS's Git repository after certain tests have
passed and all packages have been built. These channels are:

<<<<<<< HEAD
-   *Stable channels*, such as [`nixos-23.05`](https://channels.nixos.org/nixos-23.05).
=======
-   *Stable channels*, such as [`nixos-22.11`](https://nixos.org/channels/nixos-22.11).
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    These only get conservative bug fixes and package upgrades. For
    instance, a channel update may cause the Linux kernel on your system
    to be upgraded from 4.19.34 to 4.19.38 (a minor bug fix), but not
    from 4.19.x to 4.20.x (a major change that has the potential to break things).
    Stable channels are generally maintained until the next stable
    branch is created.

<<<<<<< HEAD
-   The *unstable channel*, [`nixos-unstable`](https://channels.nixos.org/nixos-unstable).
=======
-   The *unstable channel*, [`nixos-unstable`](https://nixos.org/channels/nixos-unstable).
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    This corresponds to NixOS's main development branch, and may thus see
    radical changes between channel updates. It's not recommended for
    production systems.

<<<<<<< HEAD
-   *Small channels*, such as [`nixos-23.05-small`](https://channels.nixos.org/nixos-23.05-small)
    or [`nixos-unstable-small`](https://channels.nixos.org/nixos-unstable-small).
=======
-   *Small channels*, such as [`nixos-22.11-small`](https://nixos.org/channels/nixos-22.11-small)
    or [`nixos-unstable-small`](https://nixos.org/channels/nixos-unstable-small).
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    These are identical to the stable and unstable channels described above,
    except that they contain fewer binary packages. This means they get updated
    faster than the regular channels (for instance, when a critical security patch
    is committed to NixOS's source tree), but may require more packages to be
    built from source than usual. They're mostly intended for server environments
    and as such contain few GUI applications.

<<<<<<< HEAD
To see what channels are available, go to <https://channels.nixos.org>.
=======
To see what channels are available, go to <https://nixos.org/channels>.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
(Note that the URIs of the various channels redirect to a directory that
contains the channel's latest version and includes ISO images and
VirtualBox appliances.) Please note that during the release process,
channels that are not yet released will be present here as well. See the
Getting NixOS page <https://nixos.org/nixos/download.html> to find the
newest supported stable release.

When you first install NixOS, you're automatically subscribed to the
NixOS channel that corresponds to your installation source. For
<<<<<<< HEAD
instance, if you installed from a 23.05 ISO, you will be subscribed to
the `nixos-23.05` channel. To see which NixOS channel you're subscribed
=======
instance, if you installed from a 22.11 ISO, you will be subscribed to
the `nixos-22.11` channel. To see which NixOS channel you're subscribed
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
to, run the following as root:

```ShellSession
# nix-channel --list | grep nixos
<<<<<<< HEAD
nixos https://channels.nixos.org/nixos-unstable
=======
nixos https://nixos.org/channels/nixos-unstable
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
```

To switch to a different NixOS channel, do

```ShellSession
<<<<<<< HEAD
# nix-channel --add https://channels.nixos.org/channel-name nixos
```

(Be sure to include the `nixos` parameter at the end.) For instance, to
use the NixOS 23.05 stable channel:

```ShellSession
# nix-channel --add https://channels.nixos.org/nixos-23.05 nixos
=======
# nix-channel --add https://nixos.org/channels/channel-name nixos
```

(Be sure to include the `nixos` parameter at the end.) For instance, to
use the NixOS 22.11 stable channel:

```ShellSession
# nix-channel --add https://nixos.org/channels/nixos-22.11 nixos
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
```

If you have a server, you may want to use the "small" channel instead:

```ShellSession
<<<<<<< HEAD
# nix-channel --add https://channels.nixos.org/nixos-23.05-small nixos
=======
# nix-channel --add https://nixos.org/channels/nixos-22.11-small nixos
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
```

And if you want to live on the bleeding edge:

```ShellSession
<<<<<<< HEAD
# nix-channel --add https://channels.nixos.org/nixos-unstable nixos
=======
# nix-channel --add https://nixos.org/channels/nixos-unstable nixos
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
system.autoUpgrade.enable = true;
system.autoUpgrade.allowReboot = true;
```

This enables a periodically executed systemd service named
`nixos-upgrade.service`. If the `allowReboot` option is `false`, it runs
`nixos-rebuild switch --upgrade` to upgrade NixOS to the latest version
in the current channel. (To see when the service runs, see `systemctl list-timers`.)
If `allowReboot` is `true`, then the system will automatically reboot if
the new generation contains a different kernel, initrd or kernel
modules. You can also specify a channel explicitly, e.g.

```nix
<<<<<<< HEAD
system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";
=======
system.autoUpgrade.channel = https://nixos.org/channels/nixos-22.11;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
```
