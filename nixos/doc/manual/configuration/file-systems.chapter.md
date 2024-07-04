# File Systems {#ch-file-systems}

You can define file systems using the `fileSystems` configuration
option. For instance, the following definition causes NixOS to mount the
Ext4 file system on device `/dev/disk/by-label/data` onto the mount
point `/data`:

```nix
{
  fileSystems."/data" =
    { device = "/dev/disk/by-label/data";
      fsType = "ext4";
    };
}
```

This will create an entry in `/etc/fstab`, which will generate a
corresponding [systemd.mount](https://www.freedesktop.org/software/systemd/man/systemd.mount.html)
unit via [systemd-fstab-generator](https://www.freedesktop.org/software/systemd/man/systemd-fstab-generator.html).
The filesystem will be mounted automatically unless `"noauto"` is
present in [options](#opt-fileSystems._name_.options). `"noauto"`
filesystems can be mounted explicitly using `systemctl` e.g.
`systemctl start data.mount`. Mount points are created automatically if they don't
already exist. For `device`, it's best to use the topology-independent
device aliases in `/dev/disk/by-label` and `/dev/disk/by-uuid`, as these
don't change if the topology changes (e.g. if a disk is moved to another
IDE controller).

You can usually omit the file system type (`fsType`), since `mount` can
usually detect the type and load the necessary kernel module
automatically. However, if the file system is needed at early boot (in
the initial ramdisk) and is not `ext2`, `ext3` or `ext4`, then it's best
to specify `fsType` to ensure that the kernel module is available.

::: {.note}
System startup will fail if any of the filesystems fails to mount,
dropping you to the emergency shell. You can make a mount asynchronous
and non-critical by adding `options = [ "nofail" ];`.
:::

```{=include=} sections
luks-file-systems.section.md
sshfs-file-systems.section.md
overlayfs.section.md
```
