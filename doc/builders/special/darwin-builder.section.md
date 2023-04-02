# darwin.builder {#sec-darwin-builder}

`darwin.builder` provides a way to bootstrap a Linux builder on a macOS machine.

This requires macOS version 12.4 or later.

This also requires that port 22 on your machine is free (since Nix does not
permit specifying a non-default SSH port for builders).

You will also need to be a trusted user for your Nix installation. In other
words, your `/etc/nix/nix.conf` should have something like:

```
extra-trusted-users = <your username goes here>
```

To launch the builder, run the following flake:

```ShellSession
$ nix run nixpkgs#darwin.builder
```

That will prompt you to enter your `sudo` password:

```
+ sudo --reset-timestamp /nix/store/…-install-credentials.sh ./keys
Password:
```

… so that it can install a private key used to `ssh` into the build server.
After that the script will launch the virtual machine and automatically log you
in as the `builder` user:

```
<<< Welcome to NixOS 22.11.20220901.1bd8d11 (aarch64) - ttyAMA0 >>>

Run 'nixos-help' for the NixOS manual.

nixos login: builder (automatic login)


[builder@nixos:~]$
```

> Note: When you need to stop the VM, run `shutdown now` as the `builder` user.

To delegate builds to the remote builder, add the following options to your
`nix.conf` file:

```
# - Replace ${ARCH} with either aarch64 or x86_64 to match your host machine
# - Replace ${MAX_JOBS} with the maximum number of builds (pick 4 if you're not sure)
builders = ssh-ng://builder@localhost ${ARCH}-linux /etc/nix/builder_ed25519 ${MAX_JOBS} - - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=

# Not strictly necessary, but this will reduce your disk utilization
builders-use-substitutes = true
```

… and then restart your Nix daemon to apply the change:

```ShellSession
$ sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

## As a NixOS module

The `darwin.builder` bootstrapper runs a NixOS module with sensible defaults for
two settings:

- `services.macos-builder.diskSize` &mdash; The disk space used by the VM in MB,
  with a default of 20 \* 1024 (20 GB).
- `services.macos-builder.memorySize` &mdash; The memory used by the VM in MB,
  with a default of 3 \* 1024 (3 GB).

To provide different values for these settings, you need to use the builder as a
NixOS VM on your own. Here's an example configuration:

```nix
{ modulesPath, pkgs, ... }:

{
  imports = [
    # The builder module
    "${modulesPath}/profiles/macos-builder.nix"
    # Other modules
  ];

  services.macos-builder = {
    enable = true; # Run the builder
    services.macos-builder.diskSize = 50 * 1024; # 50 GB instead of 20
    services.macos-builder.memorySize = 8 * 1024; # 8 GB instead of 3
  };
  virtualisation.host = { inherit pkgs; };

  # Other settings
}
```
