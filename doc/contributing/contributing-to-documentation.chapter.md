# Contributing to this documentation {#chap-contributing}

The DocBook sources of the Nixpkgs manual are in the [doc](https://github.com/NixOS/nixpkgs/tree/master/doc) subdirectory of the Nixpkgs repository.

You can quickly check your edits with `make`:

```ShellSession
$ cd /path/to/nixpkgs/doc
$ nix-shell
[nix-shell]$ make $makeFlags
```

If you experience problems, run `make debug` to help understand the docbook errors.

After making modifications to the manual, it's important to build it before committing. You can do that as follows:

```ShellSession
$ cd /path/to/nixpkgs/doc
$ nix-shell
[nix-shell]$ make clean
[nix-shell]$ nix-build .
```

If the build succeeds, the manual will be in `./result/share/doc/nixpkgs/manual.html`.
