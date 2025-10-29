# SSHFS File Systems {#sec-sshfs-file-systems}

[SSHFS][sshfs] is a [FUSE][fuse] filesystem that allows easy access to directories on a remote machine using the SSH File Transfer Protocol (SFTP).
It means that if you have SSH access to a machine, no additional setup is needed to mount a directory.

[sshfs]: https://github.com/libfuse/sshfs
[fuse]: https://en.wikipedia.org/wiki/Filesystem_in_Userspace

## Interactive mounting {#sec-sshfs-interactive}

In NixOS, SSHFS is packaged as `sshfs`.
Once installed, mounting a directory interactively is simple as running:
```ShellSession
$ sshfs my-user@example.com:/my-dir /mnt/my-dir
```
Like any other FUSE file system, the directory is unmounted using:
```ShellSession
$ fusermount -u /mnt/my-dir
```

## Non-interactive mounting {#sec-sshfs-non-interactive}

Mounting non-interactively requires some precautions because `sshfs` will run at boot and under a different user (root).
For obvious reason, you can't input a password, so public key authentication using an unencrypted key is needed.
To create a new key without a passphrase you can do:
```ShellSession
$ ssh-keygen -t ed25519 -P '' -f example-key
Generating public/private ed25519 key pair.
Your identification has been saved in example-key
Your public key has been saved in example-key.pub
The key fingerprint is:
SHA256:yjxl3UbTn31fLWeyLYTAKYJPRmzknjQZoyG8gSNEoIE my-user@workstation
```
To keep the key safe, change the ownership to `root:root` and make sure the permissions are `600`:
OpenSSH normally refuses to use the key if it's not well-protected.

The file system can be configured in NixOS via the usual [fileSystems](#opt-fileSystems) option.
Here's a typical setup:
```nix
{
  fileSystems."/mnt/my-dir" = {
    device = "my-user@example.com:/my-dir/";
    fsType = "sshfs";
    options = [
      # Filesystem options
      "allow_other" # for non-root access
      "_netdev" # this is a network fs
      "x-systemd.automount" # mount on demand

      # SSH options
      "reconnect" # handle connection drops
      "ServerAliveInterval=15" # keep connections alive
      "IdentityFile=/var/secrets/example-key"
    ];
  };
}
```
More options from `ssh_config(5)` can be given as well, for example you can change the default SSH port or specify a jump proxy:
```nix
{
  options = [
    "ProxyJump=bastion@example.com"
    "Port=22"
  ];
}
```
It's also possible to change the `ssh` command used by SSHFS to connect to the server.
For example:
```nix
{
  options = [
    (builtins.replaceStrings [ " " ] [ "\\040" ]
      "ssh_command=${pkgs.openssh}/bin/ssh -v -L 8080:localhost:80"
    )
  ];

}
```

::: {.note}
The escaping of spaces is needed because every option is written to the `/etc/fstab` file, which is a space-separated table.
:::

### Troubleshooting {#sec-sshfs-troubleshooting}

If you're having a hard time figuring out why mounting is failing, you can add the option `"debug"`.
This enables a verbose log in SSHFS that you can access via:
```ShellSession
$ journalctl -u $(systemd-escape -p /mnt/my-dir/).mount
Jun 22 11:41:18 workstation mount[87790]: SSHFS version 3.7.1
Jun 22 11:41:18 workstation mount[87793]: executing <ssh> <-x> <-a> <-oClearAllForwardings=yes> <-oServerAliveInterval=15> <-oIdentityFile=/var/secrets/wrong-key> <-2> <my-user@example.com> <-s> <sftp>
Jun 22 11:41:19 workstation mount[87793]: my-user@example.com: Permission denied (publickey).
Jun 22 11:41:19 workstation mount[87790]: read: Connection reset by peer
Jun 22 11:41:19 workstation systemd[1]: mnt-my\x2ddir.mount: Mount process exited, code=exited, status=1/FAILURE
Jun 22 11:41:19 workstation systemd[1]: mnt-my\x2ddir.mount: Failed with result 'exit-code'.
Jun 22 11:41:19 workstation systemd[1]: Failed to mount /mnt/my-dir.
Jun 22 11:41:19 workstation systemd[1]: mnt-my\x2ddir.mount: Consumed 54ms CPU time, received 2.3K IP traffic, sent 2.7K IP traffic.
```

::: {.note}
If the mount point contains special characters it needs to be escaped using `systemd-escape`.
This is due to the way systemd converts paths into unit names.
:::
