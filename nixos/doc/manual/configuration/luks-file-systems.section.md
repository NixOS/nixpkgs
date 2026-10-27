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
{
  boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/3f6b0024-3a44-4fde-a43a-767b872abe5d";
  fileSystems."/".device = "/dev/mapper/crypted";
}
```

Should grub be used as bootloader, and `/boot` is located on an
encrypted partition, it is necessary to add the following grub option:

```nix
{ boot.loader.grub.enableCryptodisk = true; }
```

## FIDO2 {#sec-luks-file-systems-fido2}

NixOS also supports unlocking your LUKS-Encrypted file system using a
FIDO2 compatible token. The following example adds support for
unlocking the existing LUKS2 volume `root` using any enrolled FIDO2
compatible tokens.

```nix
{
  boot.initrd = {
    luks.devices.root = {
      crypttabExtraOpts = [ "fido2-device=auto" ];
      device = "/dev/sda2";
    };
  };
}
```

All tokens that should be used for unlocking the LUKS2-encrypted volume must
first be enrolled using [systemd-cryptenroll](https://www.freedesktop.org/software/systemd/man/systemd-cryptenroll.html).
In the following example, a new key slot for the first discovered token is
added to the LUKS volume.

```ShellSession
# systemd-cryptenroll --fido2-device=auto /dev/sda2
```

Existing key slots are left intact, unless `--wipe-slot=` is specified. It is
recommended to add a recovery key that should be stored in a secure physical
location and can be entered wherever a password would be entered.

```ShellSession
# systemd-cryptenroll --recovery-key /dev/sda2
```
