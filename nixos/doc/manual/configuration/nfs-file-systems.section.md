# NFS File Systems {#sec-nfs-file-systems}

[NFS][nfs] (Network File System) allows you to mount directories from remote machines over the network.

[nfs]: https://en.wikipedia.org/wiki/Network_File_System
[nfs-man]: https://man7.org/linux/man-pages/man5/nfs.5.html

To mount NFS filesystems persistently, use the `fileSystems` option:

```nix
{
  fileSystems."/mnt/data" = {
    device = "server.example.com:/export/data";
    fsType = "nfs";
  };
}
```

## Automounting {#sec-nfs-automount}

To have NFS filesystems mounted on-demand instead of at boot, add the `noauto` and `x-systemd.automount` options:

```nix
{
  fileSystems."/mnt/data" = {
    device = "server.example.com:/export/data";
    fsType = "nfs";
    options = [
      "noauto"
      "x-systemd.automount"
    ];
  };
}
```

## Ad-hoc Mounting {#sec-nfs-adhoc}

To mount NFS filesystems ad-hoc using the `mount` command, enable NFS and required RPC services:

```nix
{
  boot.supportedFilesystems = [ "nfs" ];
}
```

Then you can mount filesystems manually:

```shell
$ sudo mount -t nfs server.example.com:/export/data /mnt/data
```

For more information on NFS mount options, see the [nfs(5) man page][nfs-man].
