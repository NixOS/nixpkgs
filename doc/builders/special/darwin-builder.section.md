# darwin.builder {#sec-darwin-builder}

`darwin.builder` provides a way to bootstrap a Linux builder on a macOS machine.

This requires macOS version 12.4 or later.

This also requires that port 22 on your machine is free (since Nix does not
permit specifying a non-default SSH port for builders).

You will also need to be a trusted user for your Nix installation.  In other
words, your `/etc/nix/nix.conf` should have something like:

```
extra-trusted-users = <your username goes here>
```

To launch the builder, run the following flake:

```ShellSession
$ nix run nixpkgs#darwin.builder
```

> Note: The first time you run this macOS will ask you if you want to open your
> firewall to accept incoming connections.  You can deny that request because it
> is not necessary to open your firewall to use the builder.
>
> This weird behavior is due to an inconsistency in macOS where it only permits
> unprivileged processes (e.g. `qemu`) to bind to privileged ports (e.g. port
> 22 for SSH) if they bind the port on all IP addresses (`0.0.0.0`) but not to
> specific IP addresses (e.g. `127.0.0.1`).  For more details, see:
> [Binding on priviledged ports on macOS](https://developer.apple.com/forums/thread/674179).
>
> This means that the `qemu` VM has to gratuitously request access to all
> network interfaces even though it only needs to bind to `127.0.0.1`.

That will prompt you to enter your `sudo` password:

```
+ sudo --reset-timestamp /nix/store/…-install-credentials.sh ./keys
Password:
```

… so that it can install a private key used to `ssh` into the build server.
After that the script will launch the virtual machine:

```
<<< Welcome to NixOS 22.11.20220901.1bd8d11 (aarch64) - ttyAMA0 >>>

Run 'nixos-help' for the NixOS manual.

nixos login:
```

> Note: When you need to stop the VM, type `Ctrl`-`a` + `c` to open the `qemu`
> prompt and then type `system_powerdown` followed by `Enter`, or run `shutdown now`
> as the `builder` user (e.g. `ssh -i keys/builder_ed25519 builder@localhost shutdown now`)

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
