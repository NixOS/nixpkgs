# Running Tests {#sec-running-nixos-tests}

You can run tests using `nix-build`. For example, to run the test
[`login.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/login.nix),
you just do:

```ShellSession
$ nix-build '<nixpkgs/nixos/tests/login.nix>'
```

or, if you don't want to rely on `NIX_PATH`:

```ShellSession
$ cd /my/nixpkgs/nixos/tests
$ nix-build login.nix
…
running the VM test script
machine: QEMU running (pid 8841)
…
6 out of 6 tests succeeded
```

After building/downloading all required dependencies, this will perform
a build that starts a QEMU/KVM virtual machine containing a NixOS
system. The virtual machine mounts the Nix store of the host; this makes
VM creation very fast, as no disk image needs to be created. Afterwards,
you can view a log of the test:

```ShellSession
$ nix-store --read-log result
```
