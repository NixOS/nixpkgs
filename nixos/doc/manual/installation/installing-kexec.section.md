# "Booting" into NixOS via kexec {#sec-booting-via-kexec}

In some cases, your system might already be booted into/preinstalled with
another Linux distribution, and booting NixOS by attaching an installation
image is quite a manual process.

This is particularly useful for (cloud) providers where you can't boot a custom
image, but get some Debian or Ubuntu installation.

In these cases, it might be easier to use `kexec` to "jump into NixOS" from the
running system, which only assumes `bash` and `kexec` to be installed on the
machine.

Note that kexec may not work correctly on some hardware, as devices are not
fully re-initialized in the process. In practice, this however is rarely the
case.

To build the necessary files from your current version of nixpkgs,
you can run:

```ShellSession
nix-build -A kexec.x86_64-linux '<nixpkgs/nixos/release.nix>'
```

This will create a `result` directory containing the following:
 - `bzImage` (the Linux kernel)
 - `initrd` (the initrd file)
 - `kexec-boot` (a shellscript invoking `kexec`)

These three files are meant to be copied over to the other already running
Linux Distribution.

Note its symlinks pointing elsewhere, so `cd` in, and use
`scp * root@$destination` to copy it over, rather than rsync.

Once you finished copying, execute `kexec-boot` *on the destination*, and after
some seconds, the machine should be booting into an (ephemeral) NixOS
installation medium.

In case you want to describe your own system closure to kexec into, instead of
the default installer image, you can build your own `configuration.nix`:

```nix
{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
  ];

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "my-ssh-pubkey"
  ];
}
```


```ShellSession
nix-build '<nixpkgs/nixos>' \
  --arg configuration ./configuration.nix
  --attr config.system.build.kexecTree
```

Make sure your `configuration.nix` does still import `netboot-minimal.nix` (or
`netboot-base.nix`).
