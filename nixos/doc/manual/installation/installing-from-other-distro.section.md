# Installing from another Linux distribution {#sec-installing-from-other-distro}

Because Nix (the package manager) & Nixpkgs (the Nix packages
collection) can both be installed on any (most?) Linux distributions,
they can be used to install NixOS in various creative ways. You can, for
instance:

1.  Install NixOS on another partition, from your existing Linux
    distribution (without the use of a USB or optical device!)

1.  Install NixOS on your hard drive from the Live CD of any Linux
    distribution.

The steps for these are the same:

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
    nixpkgs https://channels.nixos.org/nixpkgs-unstable
    ```

    As that channel gets released without running the NixOS tests, it
    will be safer to use the `nixos-*` channels instead:

    ```ShellSession
    $ nix-channel --add https://channels.nixos.org/nixos-<version> nixpkgs
    ```

    Where `<version>` corresponds to the latest version available on [channels.nixos.org](https://channels.nixos.org/).

    You must run `$ nix-channel --update` for the channel change to take effect.

1.  Install the NixOS installation tools:

    You'll need `nixos-generate-config` and `nixos-install`, but this
    also makes some man pages and `nixos-enter` available, just in case
    you want to chroot into your NixOS partition. NixOS installs these
    by default, but you don't have NixOS yet..

    ```ShellSession
    $ nix-env -f '<nixpkgs>' -iA nixos-install-tools
    ```

1.  Prepare your target partition:

    At this point it is time to prepare your target partition. Please
    refer to the partitioning, file-system creation, and mounting steps
    of [](#sec-installation)

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
