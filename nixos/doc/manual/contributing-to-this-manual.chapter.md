# Contributing to this manual {#chap-contributing}

The DocBook and CommonMark sources of NixOS' manual are in the [nixos/doc/manual](https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual) subdirectory of the [Nixpkgs](https://github.com/NixOS/nixpkgs) repository.

You can quickly check your edits with the following:

```ShellSession
$ cd /path/to/nixpkgs
$ ./nixos/doc/manual/md-to-db.sh
$ nix-build nixos/release.nix -A manual.x86_64-linux
```

If the build succeeds, the manual will be in `./result/share/doc/nixos/index.html`.
