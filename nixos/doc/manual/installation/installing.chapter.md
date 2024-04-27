# Installing NixOS {#sec-installation}

## Booting from the install medium {#sec-installation-booting}

To begin the installation, you have to boot your computer from the install drive.

1.   Plug in the install drive. Then turn on or restart your computer.

2.   Open the boot menu by pressing the appropriate key, which is usually shown
     on the display on early boot.
     Select the USB flash drive (the option usually contains the word "USB").
     If you choose the incorrect drive, your computer will likely continue to
     boot as normal. In that case restart your computer and pick a
     different drive.

     ::: {.note}
     The key to open the boot menu is different across computer brands and even
     models. It can be [F12]{.keycap}, but also [F1]{.keycap},
     [F9]{.keycap}, [F10]{.keycap}, [Enter]{.keycap}, [Del]{.keycap},
     [Esc]{.keycap} or another function key. If you are unsure and don't see
     it on the early boot screen, you can search online for your computers
     brand, model followed by "boot from usb".
     The computer might not even have that feature, so you have to go into the
     BIOS/UEFI settings to change the boot order. Again, search online for
     details about your specific computer model.

     For Apple computers with Intel processors press and hold the [⌥]{.keycap}
     (Option or Alt) key until you see the boot menu. On Apple silicon press
     and hold the power button.
     :::

     ::: {.note}
     If your computer supports both BIOS and UEFI boot, choose the UEFI option.
     :::

     ::: {.note}
     If you use a CD for the installation, the computer will probably boot from
     it automatically. If not, choose the option containing the word "CD" from
     the boot menu.
     :::

3.   Shortly after selecting the appropriate boot drive, you should be
     presented with a menu with different installer options. Leave the default
     and wait (or press [Enter]{.keycap} to speed up).

4.   The graphical images will start their corresponding desktop environment
     and the graphical installer, which can take some time. The minimal images
     will boot to a command line. You have to follow the instructions in
     [](#sec-installation-manual) there.

## Graphical Installation {#sec-installation-graphical}

The graphical installer is recommended for desktop users and will guide you
through the installation.

1.   In the "Welcome" screen, you can select the language of the Installer and
     the installed system.

     ::: {.tip}
     Leaving the language as "American English" will make it easier to search for
     error messages in a search engine or to report an issue.
     :::

2.   Next you should choose your location to have the timezone set correctly.
     You can actually click on the map!

     ::: {.note}
     The installer will use an online service to guess your location based on
     your public IP address.
     :::

3.   Then you can select the keyboard layout. The default keyboard model should
     work well with most desktop keyboards. If you have a special keyboard or
     notebook, your model might be in the list. Select the language you are most
     comfortable typing in.

4.   On the "Users" screen, you have to type in your display name, login name
     and password. You can also enable an option to automatically login to the
     desktop.

5.   Then you have the option to choose a desktop environment. If you want to
     create a custom setup with a window manager, you can select "No desktop".

     ::: {.tip}
     If you don't have a favorite desktop and don't know which one to choose,
     you can stick to either GNOME or Plasma. They have a quite different
     design, so you should choose whichever you like better.
     They are both popular choices and well tested on NixOS.
     :::

6.   You have the option to allow unfree software in the next screen.

7.   The easiest option in the "Partitioning" screen is "Erase disk", which will
     delete all data from the selected disk and install the system on it.
     Also select "Swap (with Hibernation)" in the dropdown below it.
     You have the option to encrypt the whole disk with LUKS.

     ::: {.note}
     At the top left you see if the Installer was booted with BIOS or UEFI. If
     you know your system supports UEFI and it shows "BIOS", reboot with the
     correct option.
     :::

     ::: {.warning}
     Make sure you have selected the correct disk at the top and that no
     valuable data is still on the disk! It will be deleted when
     formatting the disk.
     :::

8.   Check the choices you made in the "Summary" and click "Install".

     ::: {.note}
     The installation takes about 15 minutes. The time varies based on the
     selected desktop environment, internet connection speed and disk write speed.
     :::

9.  When the install is complete, remove the USB flash drive and
    reboot into your new system!

## Manual Installation {#sec-installation-manual}

NixOS can be installed on BIOS or UEFI systems. The procedure for a UEFI
installation is broadly the same as for a BIOS installation. The differences
are mentioned in the following steps.

The NixOS manual is available by running `nixos-help` in the command line
or from the application menu in the desktop environment.

To have access to the command line on the graphical images, open
Terminal (GNOME) or Konsole (Plasma) from the application menu.

You are logged-in automatically as `nixos`. The `nixos` user account has
an empty password so you can use `sudo` without a password:

```ShellSession
$ sudo -i
```

You can use `loadkeys` to switch to your preferred keyboard layout.
(We even provide neo2 via `loadkeys de neo`!)

If the text is too small to be legible, try `setfont ter-v32n` to
increase the font size.

To install over a serial port connect with `115200n8` (e.g.
`picocom -b 115200 /dev/ttyUSB0`). When the bootloader lists boot
entries, select the serial console boot entry.

### Networking in the installer {#sec-installation-manual-networking}
[]{#sec-installation-booting-networking} <!-- legacy anchor -->

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
configuration must be performed manually. To configure the wifi, first
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

### Partitioning and formatting {#sec-installation-manual-partitioning}
[]{#sec-installation-partitioning} <!-- legacy anchor -->

The NixOS installer doesn't do any partitioning or formatting, so you
need to do that yourself.

The NixOS installer ships with multiple partitioning tools. The examples
below use `parted`, but also provides `fdisk`, `gdisk`, `cfdisk`, and
`cgdisk`.

The recommended partition scheme differs depending if the computer uses
*Legacy Boot* or *UEFI*.

#### UEFI (GPT) {#sec-installation-manual-partitioning-UEFI}
[]{#sec-installation-partitioning-UEFI} <!-- legacy anchor -->

Here's an example partition scheme for UEFI, using `/dev/sda` as the
device.

::: {.note}
You can safely ignore `parted`'s informational message about needing to
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
    # parted /dev/sda -- mkpart root ext4 512MB -8GB
    ```

3.  Next, add a *swap* partition. The size required will vary according
    to needs, here a 8GB one is created.

    ```ShellSession
    # parted /dev/sda -- mkpart swap linux-swap -8GB 100%
    ```

    ::: {.note}
    The swap partition size rules are no different than for other Linux
    distributions.
    :::

4.  Finally, the *boot* partition. NixOS by default uses the ESP (EFI
    system partition) as its */boot* partition. It uses the initially
    reserved 512MiB at the start of the disk.

    ```ShellSession
    # parted /dev/sda -- mkpart ESP fat32 1MB 512MB
    # parted /dev/sda -- set 3 esp on
    ```
    ::: {.note}
    In case you decided to not create a swap partition, replace `3` by `2`. To be sure of the id number of ESP, run `parted --list`.
    :::

Once complete, you can follow with
[](#sec-installation-manual-partitioning-formatting).

#### Legacy Boot (MBR) {#sec-installation-manual-partitioning-MBR}
[]{#sec-installation-partitioning-MBR} <!-- legacy anchor -->

Here's an example partition scheme for Legacy Boot, using `/dev/sda` as
the device.

::: {.note}
You can safely ignore `parted`'s informational message about needing to
update /etc/fstab.
:::

1.  Create a *MBR* partition table.

    ```ShellSession
    # parted /dev/sda -- mklabel msdos
    ```

2.  Add the *root* partition. This will fill the the disk except for the
    end part, where the swap will live.

    ```ShellSession
    # parted /dev/sda -- mkpart primary 1MB -8GB
    ```

3.  Set the root partition's boot flag to on. This allows the disk to be booted from.

    ```ShellSession
    # parted /dev/sda -- set 1 boot on
    ```

4.  Finally, add a *swap* partition. The size required will vary
    according to needs, here a 8GB one is created.

    ```ShellSession
    # parted /dev/sda -- mkpart primary linux-swap -8GB 100%
    ```

    ::: {.note}
    The swap partition size rules are no different than for other Linux
    distributions.
    :::

Once complete, you can follow with
[](#sec-installation-manual-partitioning-formatting).

#### Formatting {#sec-installation-manual-partitioning-formatting}
[]{#sec-installation-partitioning-formatting} <!-- legacy anchor -->

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

### Installing {#sec-installation-manual-installing}
[]{#sec-installation-installing} <!-- legacy anchor -->

1.  Mount the target file system on which NixOS should be installed on
    `/mnt`, e.g.

    ```ShellSession
    # mount /dev/disk/by-label/nixos /mnt
    ```

2.  **UEFI systems**

    Mount the boot file system on `/mnt/boot`, e.g.

    ```ShellSession
    # mkdir -p /mnt/boot
    # mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
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

        If there are other operating systems running on the machine before
        installing NixOS, the [](#opt-boot.loader.grub.useOSProber)
        option can be set to `true` to automatically add them to the grub
        menu.

    UEFI systems

    :   You must select a boot-loader, either systemd-boot or GRUB. The recommended
        option is systemd-boot: set the option [](#opt-boot.loader.systemd-boot.enable)
        to `true`. `nixos-generate-config` should do this automatically
        for new configurations when booted in UEFI mode.

        You may want to look at the options starting with
        [`boot.loader.efi`](#opt-boot.loader.efi.canTouchEfiVariables) and
        [`boot.loader.systemd-boot`](#opt-boot.loader.systemd-boot.enable)
        as well.

        If you want to use GRUB, set [](#opt-boot.loader.grub.device) to `nodev` and
        [](#opt-boot.loader.grub.efiSupport) to `true`.

        With systemd-boot, you should not need any special configuration to detect
        other installed systems. With GRUB, set [](#opt-boot.loader.grub.useOSProber)
        to `true`, but this will only detect windows partitions, not other Linux
        distributions. If you dual boot another Linux distribution, use systemd-boot
        instead.

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

### Installation summary {#sec-installation-manual-summary}
[]{#sec-installation-summary} <!-- legacy anchor -->

To summarise, [Example: Commands for Installing NixOS on `/dev/sda`](#ex-install-sequence)
shows a typical sequence of commands for installing NixOS on an empty hard
drive (here `/dev/sda`). [Example: NixOS Configuration](#ex-config) shows a
corresponding configuration Nix expression.

::: {#ex-partition-scheme-MBR .example}
### Example partition schemes for NixOS on `/dev/sda` (MBR)
```ShellSession
# parted /dev/sda -- mklabel msdos
# parted /dev/sda -- mkpart primary 1MB -8GB
# parted /dev/sda -- mkpart primary linux-swap -8GB 100%
```
:::

::: {#ex-partition-scheme-UEFI .example}
### Example partition schemes for NixOS on `/dev/sda` (UEFI)
```ShellSession
# parted /dev/sda -- mklabel gpt
# parted /dev/sda -- mkpart root ext4 512MB -8GB
# parted /dev/sda -- mkpart swap linux-swap -8GB 100%
# parted /dev/sda -- mkpart ESP fat32 1MB 512MB
# parted /dev/sda -- set 3 esp on
```
:::

::: {#ex-install-sequence .example}
### Commands for Installing NixOS on `/dev/sda`

With a partitioned disk.

```ShellSession
# mkfs.ext4 -L nixos /dev/sda1
# mkswap -L swap /dev/sda2
# swapon /dev/sda2
# mkfs.fat -F 32 -n boot /dev/sda3        # (for UEFI systems only)
# mount /dev/disk/by-label/nixos /mnt
# mkdir -p /mnt/boot                      # (for UEFI systems only)
# mount -o umask=077 /dev/disk/by-label/boot /mnt/boot # (for UEFI systems only)
# nixos-generate-config --root /mnt
# nano /mnt/etc/nixos/configuration.nix
# nixos-install
# reboot
```
:::

::: {#ex-config .example}
### Example: NixOS Configuration
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

```{=include=} sections
installing-usb.section.md
installing-pxe.section.md
installing-kexec.section.md
installing-virtualbox-guest.section.md
installing-from-other-distro.section.md
installing-behind-a-proxy.section.md
```
