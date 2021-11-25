# Installing NixOS {#sec-installation}

## Booting the system {#sec-installation-booting}

NixOS can be installed on BIOS or UEFI systems. The procedure for a UEFI
installation is by and large the same as a BIOS installation. The
differences are mentioned in the steps that follow.

The installation media can be burned to a CD, or now more commonly,
"burned" to a USB drive (see [](#sec-booting-from-usb)).

The installation media contains a basic NixOS installation. When it's
finished booting, it should have detected most of your hardware.

The NixOS manual is available by running `nixos-help`.

You are logged-in automatically as `nixos`. The `nixos` user account has
an empty password so you can use `sudo` without a password:
```ShellSession
$ sudo -i
```

If you downloaded the graphical ISO image, you can run `systemctl
start display-manager` to start the desktop environment. If you want
to continue on the terminal, you can use `loadkeys` to switch to your
preferred keyboard layout. (We even provide neo2 via `loadkeys de
neo`!)

If the text is too small to be legible, try `setfont ter-v32n` to
increase the font size.

To install over a serial port connect with `115200n8` (e.g.
`picocom -b 115200 /dev/ttyUSB0`). When the bootloader lists boot
entries, select the serial console boot entry.

### Networking in the installer {#sec-installation-booting-networking}

The boot process should have brought up networking (check `ip
a`). Networking is necessary for the installer, since it will
download lots of stuff (such as source tarballs or Nixpkgs channel
binaries). It's best if you have a DHCP server on your network.
Otherwise configure networking manually using `ifconfig`.

On the graphical installer, you can configure the network, wifi
included, through NetworkManager. Using the `nmtui` program, you can do
so even in a non-graphical session. If you prefer to configure the
network manually, disable NetworkManager with
`systemctl stop NetworkManager`.

On the minimal installer, NetworkManager is not available, so
configuration must be perfomed manually. To configure the wifi, first
start wpa_supplicant with `sudo systemctl start wpa_supplicant`, then
run `wpa_cli`. For most home networks, you need to type in the following
commands:

```plain
> add_network
0
> set_network 0 ssid "myhomenetwork"
OK
> set_network 0 psk "mypassword"
OK
> set_network 0 key_mgmt WPA-PSK
OK
> enable_network 0
OK
```

For enterprise networks, for example *eduroam*, instead do:

```plain
> add_network
0
> set_network 0 ssid "eduroam"
OK
> set_network 0 identity "myname@example.com"
OK
> set_network 0 password "mypassword"
OK
> set_network 0 key_mgmt WPA-EAP
OK
> enable_network 0
OK
```

When successfully connected, you should see a line such as this one

```plain
<3>CTRL-EVENT-CONNECTED - Connection to 32:85:ab:ef:24:5c completed [id=0 id_str=]
```

you can now leave `wpa_cli` by typing `quit`.

If you would like to continue the installation from a different machine
you can use activated SSH daemon. You need to copy your ssh key to
either `/home/nixos/.ssh/authorized_keys` or
`/root/.ssh/authorized_keys` (Tip: For installers with a modifiable
filesystem such as the sd-card installer image a key can be manually
placed by mounting the image on a different machine). Alternatively you
must set a password for either `root` or `nixos` with `passwd` to be
able to login.

## Partitioning and formatting {#sec-installation-partitioning}

The NixOS installer doesn't do any partitioning or formatting, so you
need to do that yourself.

The NixOS installer ships with multiple partitioning tools. The examples
below use `parted`, but also provides `fdisk`, `gdisk`, `cfdisk`, and
`cgdisk`.

The recommended partition scheme differs depending if the computer uses
*Legacy Boot* or *UEFI*.

### UEFI (GPT) {#sec-installation-partitioning-UEFI}

Here\'s an example partition scheme for UEFI, using `/dev/sda` as the
device.

::: {.note}
You can safely ignore `parted`\'s informational message about needing to
update /etc/fstab.
:::

1.  Create a *GPT* partition table.

    ```ShellSession
    # parted /dev/sda -- mklabel gpt
    ```

2.  Add the *root* partition. This will fill the disk except for the end
    part, where the swap will live, and the space left in front (512MiB)
    which will be used by the boot partition.

    ```ShellSession
    # parted /dev/sda -- mkpart primary 512MiB -8GiB
    ```

3.  Next, add a *swap* partition. The size required will vary according
    to needs, here a 8GiB one is created.

    ```ShellSession
    # parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
    ```

    ::: {.note}
    The swap partition size rules are no different than for other Linux
    distributions.
    :::

4.  Finally, the *boot* partition. NixOS by default uses the ESP (EFI
    system partition) as its */boot* partition. It uses the initially
    reserved 512MiB at the start of the disk.

    ```ShellSession
    # parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
    # parted /dev/sda -- set 3 esp on
    ```

Once complete, you can follow with
[](#sec-installation-partitioning-formatting).

### Legacy Boot (MBR) {#sec-installation-partitioning-MBR}

Here\'s an example partition scheme for Legacy Boot, using `/dev/sda` as
the device.

::: {.note}
You can safely ignore `parted`\'s informational message about needing to
update /etc/fstab.
:::

1.  Create a *MBR* partition table.

    ```ShellSession
    # parted /dev/sda -- mklabel msdos
    ```

2.  Add the *root* partition. This will fill the the disk except for the
    end part, where the swap will live.

    ```ShellSession
    # parted /dev/sda -- mkpart primary 1MiB -8GiB
    ```

3.  Finally, add a *swap* partition. The size required will vary
    according to needs, here a 8GiB one is created.

    ```ShellSession
    # parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
    ```

    ::: {.note}
    The swap partition size rules are no different than for other Linux
    distributions.
    :::

Once complete, you can follow with
[](#sec-installation-partitioning-formatting).

### Formatting {#sec-installation-partitioning-formatting}

Use the following commands:

-   For initialising Ext4 partitions: `mkfs.ext4`. It is recommended
    that you assign a unique symbolic label to the file system using the
    option `-L label`, since this makes the file system configuration
    independent from device changes. For example:

    ```ShellSession
    # mkfs.ext4 -L nixos /dev/sda1
    ```

-   For creating swap partitions: `mkswap`. Again it's recommended to
    assign a label to the swap partition: `-L label`. For example:

    ```ShellSession
    # mkswap -L swap /dev/sda2
    ```

-   **UEFI systems**

    For creating boot partitions: `mkfs.fat`. Again it's recommended
    to assign a label to the boot partition: `-n label`. For
    example:

    ```ShellSession
    # mkfs.fat -F 32 -n boot /dev/sda3
    ```

-   For creating LVM volumes, the LVM commands, e.g., `pvcreate`,
    `vgcreate`, and `lvcreate`.

-   For creating software RAID devices, use `mdadm`.

## Installing {#sec-installation-installing}

1.  Mount the target file system on which NixOS should be installed on
    `/mnt`, e.g.

    ```ShellSession
    # mount /dev/disk/by-label/nixos /mnt
    ```

2.  **UEFI systems**

    Mount the boot file system on `/mnt/boot`, e.g.

    ```ShellSession
    # mkdir -p /mnt/boot
    # mount /dev/disk/by-label/boot /mnt/boot
    ```

3.  If your machine has a limited amount of memory, you may want to
    activate swap devices now (`swapon device`).
    The installer (or rather, the build actions that it
    may spawn) may need quite a bit of RAM, depending on your
    configuration.

    ```ShellSession
    # swapon /dev/sda2
    ```

4.  You now need to create a file `/mnt/etc/nixos/configuration.nix`
    that specifies the intended configuration of the system. This is
    because NixOS has a *declarative* configuration model: you create or
    edit a description of the desired configuration of your system, and
    then NixOS takes care of making it happen. The syntax of the NixOS
    configuration file is described in [](#sec-configuration-syntax),
    while a list of available configuration options appears in
    [](#ch-options). A minimal example is shown in
    [Example: NixOS Configuration](#ex-config).

    The command `nixos-generate-config` can generate an initial
    configuration file for you:

    ```ShellSession
    # nixos-generate-config --root /mnt
    ```

    You should then edit `/mnt/etc/nixos/configuration.nix` to suit your
    needs:

    ```ShellSession
    # nano /mnt/etc/nixos/configuration.nix
    ```

    If you're using the graphical ISO image, other editors may be
    available (such as `vim`). If you have network access, you can also
    install other editors -- for instance, you can install Emacs by
    running `nix-env -f '<nixpkgs>' -iA emacs`.

    BIOS systems

    :   You *must* set the option [](#opt-boot.loader.grub.device) to
        specify on which disk the GRUB boot loader is to be installed.
        Without it, NixOS cannot boot.

    UEFI systems

    :   You *must* set the option [](#opt-boot.loader.systemd-boot.enable)
        to `true`. `nixos-generate-config` should do this automatically
        for new configurations when booted in UEFI mode.

        You may want to look at the options starting with
        [`boot.loader.efi`](#opt-boot.loader.efi.canTouchEfiVariables) and
        [`boot.loader.systemd-boot`](#opt-boot.loader.systemd-boot.enable)
        as well.

    If there are other operating systems running on the machine before
    installing NixOS, the [](#opt-boot.loader.grub.useOSProber)
    option can be set to `true` to automatically add them to the grub
    menu.

    If you need to configure networking for your machine the
    configuration options are described in [](#sec-networking). In
    particular, while wifi is supported on the installation image, it is
    not enabled by default in the configuration generated by
    `nixos-generate-config`.

    Another critical option is `fileSystems`, specifying the file
    systems that need to be mounted by NixOS. However, you typically
    don't need to set it yourself, because `nixos-generate-config` sets
    it automatically in `/mnt/etc/nixos/hardware-configuration.nix` from
    your currently mounted file systems. (The configuration file
    `hardware-configuration.nix` is included from `configuration.nix`
    and will be overwritten by future invocations of
    `nixos-generate-config`; thus, you generally should not modify it.)
    Additionally, you may want to look at [Hardware configuration for
    known-hardware](https://github.com/NixOS/nixos-hardware) at this
    point or after installation.

    ::: {.note}
    Depending on your hardware configuration or type of file system, you
    may need to set the option `boot.initrd.kernelModules` to include
    the kernel modules that are necessary for mounting the root file
    system, otherwise the installed system will not be able to boot. (If
    this happens, boot from the installation media again, mount the
    target file system on `/mnt`, fix `/mnt/etc/nixos/configuration.nix`
    and rerun `nixos-install`.) In most cases, `nixos-generate-config`
    will figure out the required modules.
    :::

5.  Do the installation:

    ```ShellSession
    # nixos-install
    ```

    This will install your system based on the configuration you
    provided. If anything fails due to a configuration problem or any
    other issue (such as a network outage while downloading binaries
    from the NixOS binary cache), you can re-run `nixos-install` after
    fixing your `configuration.nix`.

    As the last step, `nixos-install` will ask you to set the password
    for the `root` user, e.g.

    ```plain
    setting root password...
    New password: ***
    Retype new password: ***
    ```

    ::: {.note}
    For unattended installations, it is possible to use
    `nixos-install --no-root-passwd` in order to disable the password
    prompt entirely.
    :::

6.  If everything went well:

    ```ShellSession
    # reboot
    ```

7.  You should now be able to boot into the installed NixOS. The GRUB
    boot menu shows a list of *available configurations* (initially just
    one). Every time you change the NixOS configuration (see [Changing
    Configuration](#sec-changing-config)), a new item is added to the
    menu. This allows you to easily roll back to a previous
    configuration if something goes wrong.

    You should log in and change the `root` password with `passwd`.

    You'll probably want to create some user accounts as well, which can
    be done with `useradd`:

    ```ShellSession
    $ useradd -c 'Eelco Dolstra' -m eelco
    $ passwd eelco
    ```

    You may also want to install some software. This will be covered in
    [](#sec-package-management).

## Installation summary {#sec-installation-summary}

To summarise, [Example: Commands for Installing NixOS on `/dev/sda`](#ex-install-sequence)
shows a typical sequence of commands for installing NixOS on an empty hard
drive (here `/dev/sda`). [Example: NixOS Configuration](#ex-config) shows a
corresponding configuration Nix expression.

::: {#ex-partition-scheme-MBR .example}
::: {.title}
**Example: Example partition schemes for NixOS on `/dev/sda` (MBR)**
:::
```ShellSession
# parted /dev/sda -- mklabel msdos
# parted /dev/sda -- mkpart primary 1MiB -8GiB
# parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
```
:::

::: {#ex-partition-scheme-UEFI .example}
::: {.title}
**Example: Example partition schemes for NixOS on `/dev/sda` (UEFI)**
:::
```ShellSession
# parted /dev/sda -- mklabel gpt
# parted /dev/sda -- mkpart primary 512MiB -8GiB
# parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
# parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
# parted /dev/sda -- set 3 esp on
```
:::

::: {#ex-install-sequence .example}
::: {.title}
**Example: Commands for Installing NixOS on `/dev/sda`**
:::
With a partitioned disk.

```ShellSession
# mkfs.ext4 -L nixos /dev/sda1
# mkswap -L swap /dev/sda2
# swapon /dev/sda2
# mkfs.fat -F 32 -n boot /dev/sda3        # (for UEFI systems only)
# mount /dev/disk/by-label/nixos /mnt
# mkdir -p /mnt/boot                      # (for UEFI systems only)
# mount /dev/disk/by-label/boot /mnt/boot # (for UEFI systems only)
# nixos-generate-config --root /mnt
# nano /mnt/etc/nixos/configuration.nix
# nixos-install
# reboot
```
:::

::: {#ex-config .example}
::: {.title}
**Example: NixOS Configuration**
:::
```ShellSession
{ config, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.grub.device = "/dev/sda";   # (for BIOS systems only)
  boot.loader.systemd-boot.enable = true; # (for UEFI systems only)

  # Note: setting fileSystems is generally not
  # necessary, since nixos-generate-config figures them out
  # automatically in hardware-configuration.nix.
  #fileSystems."/".device = "/dev/disk/by-label/nixos";

  # Enable the OpenSSH server.
  services.sshd.enable = true;
}
```
:::

## Additional installation notes {#sec-installation-additional-notes}

```{=docbook}
<xi:include href="installing-usb.section.xml" />
<xi:include href="installing-pxe.section.xml" />
<xi:include href="installing-virtualbox-guest.section.xml" />
<xi:include href="installing-from-other-distro.section.xml" />
<xi:include href="installing-behind-a-proxy.section.xml" />
```
