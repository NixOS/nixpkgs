# Contributing to this manual {#chap-contributing}

The [DocBook] and CommonMark sources of the NixOS manual are in the [nixos/doc/manual](https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual) subdirectory of the [Nixpkgs](https://github.com/NixOS/nixpkgs) repository.

You can quickly check your edits with the following:

```ShellSession
$ cd /path/to/nixpkgs
$ ./nixos/doc/manual/md-to-db.sh
$ nix-build nixos/release.nix -A manual.x86_64-linux
```

If the build succeeds, the manual will be in `./result/share/doc/nixos/index.html`.

**Contributing to the man pages**

The man pages are written in [DocBook] which is XML.

To see what your edits look like:

```ShellSession
$ cd /path/to/nixpkgs
$ nix-build nixos/release.nix -A manpages.x86_64-linux
```

You can then read the man page you edited by running

```ShellSession
$ man --manpath=result/share/man nixos-rebuild # Replace nixos-rebuild with the command whose manual you edited
```

If you're on a different architecture that's supported by NixOS (check nixos/release.nix) then replace `x86_64-linux` with the architecture.
`nix-build` will complain otherwise, but should also tell you which architecture you have + the supported ones.

[DocBook]: https://en.wikipedia.org/wiki/DocBook
