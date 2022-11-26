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

You can download a `nixos.kexecTarball` build corresponding
to your system from the `nixos-YY.MM` jobsets (or
`trunk-combined` for unstable) on [the NixOS Hydra
project](https://hydra.nixos.org/project/nixos). This contains the
following:
 - `kernel` (the Linux kernel)
 - `initrd` (the initrd file)
 - `kernel-params` (the kernel command-line parameters)
 - `kexec-boot` (a shell script invoking `kexec`)

Alternatively, you can get a tarball corresponding to an existing
Nix installation's current version of nixpkgs:

```ShellSession
nix-build -A kexecTarball.x86_64-linux '<nixpkgs/nixos/release.nix>'
```

This file is meant to be copied over to the other already running
Linux distribution.

Once you finish copying and extracting, execute `kexec-boot` *on the
destination*, and after some seconds, the machine should be booting into an
(ephemeral) NixOS installation medium.

You can also enable SSH login as the `nixos` user by specifying an authorized
keys file, or append additional parameters to the kernel command line:

```ShellSession
./kexec-boot \
  --ssh-authorized-keys ~/.ssh/authorized_keys \
  --append 'panic=30 boot.panic_on_fail'
```

In case you want to customize things further, you can build your own
`configuration.nix` to describe a system closure to kexec into instead of
the default installer image:

```nix
{ pkgs, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
  ];

  environment.systemPackages = [ pkgs.kakoune ];

  users.users.nixos = {
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "my-ssh-pubkey"
    ];
  };
}
```

```ShellSession
nix-build '<nixpkgs/nixos>' \
  --arg configuration ./configuration.nix \
  --attr config.system.build.kexecTarball
```

Make sure your `configuration.nix` does still import `netboot-minimal.nix` (or
`netboot-base.nix`).
