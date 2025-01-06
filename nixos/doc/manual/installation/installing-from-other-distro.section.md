# Installing from another Linux distribution {#sec-installing-from-other-distro}

Because Nix (the package manager) & Nixpkgs (the Nix packages
collection) can both be installed on any (most?) Linux distributions,
they can be used to install NixOS in various creative ways. You can, for
instance:

1.  Install NixOS on another partition, from your existing Linux
    distribution (without the use of a USB or optical device!)

1.  Install NixOS on the same partition (in place!), from your existing
    non-NixOS Linux distribution using `NIXOS_LUSTRATE`.

1.  Install NixOS on your hard drive from the Live CD of any Linux
    distribution.

The first steps to all these are the same:

1.  Install the Nix package manager:

    Short version:

    ```ShellSession
    $ curl -L https://nixos.org/nix/install | sh
    $ . $HOME/.nix-profile/etc/profile.d/nix.sh # …or open a fresh shell
    ```

    More details in the [ Nix
    manual](https://nixos.org/nix/manual/#chap-quick-start)

1.  Switch to the NixOS channel:

    If you've just installed Nix on a non-NixOS distribution, you will
    be on the `nixpkgs` channel by default.

    ```ShellSession
    $ nix-channel --list
    nixpkgs https://nixos.org/channels/nixpkgs-unstable
    ```

    As that channel gets released without running the NixOS tests, it
    will be safer to use the `nixos-*` channels instead:

    ```ShellSession
    $ nix-channel --add https://nixos.org/channels/nixos-<version> nixpkgs
    ```

    Where `<version>` corresponds to the latest version available on [channels.nixos.org](https://channels.nixos.org/).

    You may want to throw in a `nix-channel --update` for good measure.

1.  Install the NixOS installation tools:

    You'll need `nixos-generate-config` and `nixos-install`, but this
    also makes some man pages and `nixos-enter` available, just in case
    you want to chroot into your NixOS partition. NixOS installs these
    by default, but you don't have NixOS yet..

    ```ShellSession
    $ nix-env -f '<nixpkgs>' -iA nixos-install-tools
    ```

1.  ::: {.note}
    The following 5 steps are only for installing NixOS to another
    partition. For installing NixOS in place using `NIXOS_LUSTRATE`,
    skip ahead.
    :::

    Prepare your target partition:

    At this point it is time to prepare your target partition. Please
    refer to the partitioning, file-system creation, and mounting steps
    of [](#sec-installation)

    If you're about to install NixOS in place using `NIXOS_LUSTRATE`
    there is nothing to do for this step.

1.  Generate your NixOS configuration:

    ```ShellSession
    $ sudo `which nixos-generate-config` --root /mnt
    ```

    You'll probably want to edit the configuration files. Refer to the
    `nixos-generate-config` step in [](#sec-installation) for more
    information.

    Consider setting up the NixOS bootloader to give you the ability to
    boot on your existing Linux partition. For instance, if you're
    using GRUB and your existing distribution is running Ubuntu, you may
    want to add something like this to your `configuration.nix`:

    ```nix
    {
      boot.loader.grub.extraEntries = ''
        menuentry "Ubuntu" {
          search --set=ubuntu --fs-uuid 3cc3e652-0c1f-4800-8451-033754f68e6e
          configfile "($ubuntu)/boot/grub/grub.cfg"
        }
      '';
    }
    ```

    (You can find the appropriate UUID for your partition in
    `/dev/disk/by-uuid`)

1.  Create the `nixbld` group and user on your original distribution:

    ```ShellSession
    $ sudo groupadd -g 30000 nixbld
    $ sudo useradd -u 30000 -g nixbld -G nixbld nixbld
    ```

1.  Download/build/install NixOS:

    ::: {.warning}
    Once you complete this step, you might no longer be able to boot on
    existing systems without the help of a rescue USB drive or similar.
    :::

    ::: {.note}
    On some distributions there are separate PATHS for programs intended
    only for root. In order for the installation to succeed, you might
    have to use `PATH="$PATH:/usr/sbin:/sbin"` in the following command.
    :::

    ```ShellSession
    $ sudo PATH="$PATH" `which nixos-install` --root /mnt
    ```

    Again, please refer to the `nixos-install` step in
    [](#sec-installation) for more information.

    That should be it for installation to another partition!

1.  Optionally, you may want to clean up your non-NixOS distribution:

    ```ShellSession
    $ sudo userdel nixbld
    $ sudo groupdel nixbld
    ```

    If you do not wish to keep the Nix package manager installed either,
    run something like `sudo rm -rv ~/.nix-* /nix` and remove the line
    that the Nix installer added to your `~/.profile`.

1.  ::: {.note}
    The following steps are only for installing NixOS in place using
    `NIXOS_LUSTRATE`:
    :::

    Generate your NixOS configuration:

    ```ShellSession
    $ sudo `which nixos-generate-config`
    ```

    Note that this will place the generated configuration files in
    `/etc/nixos`. You'll probably want to edit the configuration files.
    Refer to the `nixos-generate-config` step in
    [](#sec-installation) for more information.

    You'll likely want to set a root password for your first boot using
    the configuration files because you won't have a chance to enter a
    password until after you reboot. You can initialize the root password
    to an empty one with this line: (and of course don't forget to set
    one once you've rebooted or to lock the account with
    `sudo passwd -l root` if you use `sudo`)

    ```nix
    {
      users.users.root.initialHashedPassword = "";
    }
    ```

1.  Build the NixOS closure and install it in the `system` profile:

    ```ShellSession
    $ nix-env -p /nix/var/nix/profiles/system -f '<nixpkgs/nixos>' -I nixos-config=/etc/nixos/configuration.nix -iA system
    ```

1.  Change ownership of the `/nix` tree to root (since your Nix install
    was probably single user):

    ```ShellSession
    $ sudo chown -R 0:0 /nix
    ```

1.  Set up the `/etc/NIXOS` and `/etc/NIXOS_LUSTRATE` files:

    `/etc/NIXOS` officializes that this is now a NixOS partition (the
    bootup scripts require its presence).

    `/etc/NIXOS_LUSTRATE` tells the NixOS bootup scripts to move
    *everything* that's in the root partition to `/old-root`. This will
    move your existing distribution out of the way in the very early
    stages of the NixOS bootup. There are exceptions (we do need to keep
    NixOS there after all), so the NixOS lustrate process will not
    touch:

    -   The `/nix` directory

    -   The `/boot` directory

    -   Any file or directory listed in `/etc/NIXOS_LUSTRATE` (one per
        line)

    ::: {.note}
    Support for `NIXOS_LUSTRATE` was added in NixOS 16.09. The act of
    "lustrating" refers to the wiping of the existing distribution.
    Creating `/etc/NIXOS_LUSTRATE` can also be used on NixOS to remove
    all mutable files from your root partition (anything that's not in
    `/nix` or `/boot` gets "lustrated" on the next boot.

    lustrate /ˈlʌstreɪt/ verb.

    purify by expiatory sacrifice, ceremonial washing, or some other
    ritual action.
    :::

    Let's create the files:

    ```ShellSession
    $ sudo touch /etc/NIXOS
    $ sudo touch /etc/NIXOS_LUSTRATE
    ```

    Let's also make sure the NixOS configuration files are kept once we
    reboot on NixOS:

    ```ShellSession
    $ echo etc/nixos | sudo tee -a /etc/NIXOS_LUSTRATE
    ```

1.  Finally, move the `/boot` directory of your current distribution out
    of the way (the lustrate process will take care of the rest once you
    reboot, but this one must be moved out now because NixOS needs to
    install its own boot files:

    ::: {.warning}
    Once you complete this step, your current distribution will no
    longer be bootable! If you didn't get all the NixOS configuration
    right, especially those settings pertaining to boot loading and root
    partition, NixOS may not be bootable either. Have a USB rescue
    device ready in case this happens.
    :::

    ```ShellSession
    $ sudo mv -v /boot /boot.bak &&
    sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot
    ```

    Cross your fingers, reboot, hopefully you should get a NixOS prompt!

1.  If for some reason you want to revert to the old distribution,
    you'll need to boot on a USB rescue disk and do something along
    these lines:

    ```ShellSession
    # mkdir root
    # mount /dev/sdaX root
    # mkdir root/nixos-root
    # mv -v root/* root/nixos-root/
    # mv -v root/nixos-root/old-root/* root/
    # mv -v root/boot.bak root/boot  # We had renamed this by hand earlier
    # umount root
    # reboot
    ```

    This may work as is or you might also need to reinstall the boot
    loader.

    And of course, if you're happy with NixOS and no longer need the
    old distribution:

    ```ShellSession
    sudo rm -rf /old-root
    ```

1.  It's also worth noting that this whole process can be automated.
    This is especially useful for Cloud VMs, where provider do not
    provide NixOS. For instance,
    [nixos-infect](https://github.com/elitak/nixos-infect) uses the
    lustrate process to convert Digital Ocean droplets to NixOS from
    other distributions automatically.
