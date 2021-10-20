# LUKS-Encrypted File Systems {#sec-luks-file-systems}

NixOS supports file systems that are encrypted using *LUKS* (Linux
Unified Key Setup). For example, here is how you create an encrypted
Ext4 file system on the device
`/dev/disk/by-uuid/3f6b0024-3a44-4fde-a43a-767b872abe5d`:

```ShellSession
# cryptsetup luksFormat /dev/disk/by-uuid/3f6b0024-3a44-4fde-a43a-767b872abe5d

WARNING!
========
This will overwrite data on /dev/disk/by-uuid/3f6b0024-3a44-4fde-a43a-767b872abe5d irrevocably.

Are you sure? (Type uppercase yes): YES
Enter LUKS passphrase: ***
Verify passphrase: ***

# cryptsetup luksOpen /dev/disk/by-uuid/3f6b0024-3a44-4fde-a43a-767b872abe5d crypted
Enter passphrase for /dev/disk/by-uuid/3f6b0024-3a44-4fde-a43a-767b872abe5d: ***

# mkfs.ext4 /dev/mapper/crypted
```

The LUKS volume should be automatically picked up by
`nixos-generate-config`, but you might want to verify that your
`hardware-configuration.nix` looks correct. To manually ensure that the
system is automatically mounted at boot time as `/`, add the following
to `configuration.nix`:

```nix
boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/3f6b0024-3a44-4fde-a43a-767b872abe5d";
fileSystems."/".device = "/dev/mapper/crypted";
```

Should grub be used as bootloader, and `/boot` is located on an
encrypted partition, it is necessary to add the following grub option:

```nix
boot.loader.grub.enableCryptodisk = true;
```

## FIDO2 {#sec-luks-file-systems-fido2}

NixOS also supports unlocking your LUKS-Encrypted file system using a
FIDO2 compatible token. In the following example, we will create a new
FIDO2 credential and add it as a new key to our existing device
`/dev/sda2`:

```ShellSession
# export FIDO2_LABEL="/dev/sda2 @ $HOSTNAME"
# fido2luks credential "$FIDO2_LABEL"
f1d00200108b9d6e849a8b388da457688e3dd653b4e53770012d8f28e5d3b269865038c346802f36f3da7278b13ad6a3bb6a1452e24ebeeaa24ba40eef559b1b287d2a2f80b7

# fido2luks -i add-key /dev/sda2 f1d00200108b9d6e849a8b388da457688e3dd653b4e53770012d8f28e5d3b269865038c346802f36f3da7278b13ad6a3bb6a1452e24ebeeaa24ba40eef559b1b287d2a2f80b7
Password:
Password (again):
Old password:
Old password (again):
Added to key to device /dev/sda2, slot: 2
```

To ensure that this file system is decrypted using the FIDO2 compatible
key, add the following to `configuration.nix`:

```nix
boot.initrd.luks.fido2Support = true;
boot.initrd.luks.devices."/dev/sda2".fido2.credential = "f1d00200108b9d6e849a8b388da457688e3dd653b4e53770012d8f28e5d3b269865038c346802f36f3da7278b13ad6a3bb6a1452e24ebeeaa24ba40eef559b1b287d2a2f80b7";
```

You can also use the FIDO2 passwordless setup, but for security reasons,
you might want to enable it only when your device is PIN protected, such
as [Trezor](https://trezor.io/).

```nix
boot.initrd.luks.devices."/dev/sda2".fido2.passwordLess = true;
```
