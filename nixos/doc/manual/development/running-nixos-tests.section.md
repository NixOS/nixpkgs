# Running Tests {#sec-running-nixos-tests}

You can run tests using `nix-build`. For example, to run the test
[`login.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/login.nix),
you do:

```ShellSession
$ cd /my/git/clone/of/nixpkgs
$ nix-build -A nixosTests.login
```

After building/downloading all required dependencies, this will perform
a build that starts a QEMU/KVM virtual machine containing a NixOS
system. The virtual machine mounts the Nix store of the host; this makes
VM creation very fast, as no disk image needs to be created. Afterwards,
you can view a log of the test:

```ShellSession
$ nix-store --read-log result
```

## System Requirements {#sec-running-nixos-tests-requirements}

NixOS tests require virtualization support.
This means that the machine must have `kvm` in its [system features](https://nixos.org/manual/nix/stable/command-ref/conf-file.html?highlight=system-features#conf-system-features) list, or `apple-virt` in case of macOS.
These features are autodetected locally, but `apple-virt` is only autodetected since Nix 2.19.0.

Features of **remote builders** must additionally be configured manually on the client, e.g. on NixOS with [`nix.buildMachines.*.supportedFeatures`](https://search.nixos.org/options?show=nix.buildMachines.*.supportedFeatures&sort=alpha_asc&query=nix.buildMachines) or through general [Nix configuration](https://nixos.org/manual/nix/stable/advanced-topics/distributed-builds).

If you run the tests on a **macOS** machine, you also need a "remote" builder for Linux; possibly a VM. [nix-darwin](https://daiderd.com/nix-darwin/) users may enable [`nix.linux-builder.enable`](https://daiderd.com/nix-darwin/manual/index.html#opt-nix.linux-builder.enable) to launch such a VM.
