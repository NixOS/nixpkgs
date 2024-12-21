# pkgs.mkBinaryCache {#sec-pkgs-binary-cache}

`pkgs.mkBinaryCache` is a function for creating Nix flat-file binary caches.
Such a cache exists as a directory on disk, and can be used as a Nix substituter by passing `--substituter file:///path/to/cache` to Nix commands.

Nix packages are most commonly shared between machines using [HTTP, SSH, or S3](https://nixos.org/manual/nix/stable/package-management/sharing-packages.html), but a flat-file binary cache can still be useful in some situations.
For example, you can copy it directly to another machine, or make it available on a network file system.
It can also be a convenient way to make some Nix packages available inside a container via bind-mounting.

`mkBinaryCache` expects an argument with the `rootPaths` attribute.
`rootPaths` must be a list of derivations.
The transitive closure of these derivations' outputs will be copied into the cache.

::: {.note}
This function is meant for advanced use cases.
The more idiomatic way to work with flat-file binary caches is via the [nix-copy-closure](https://nixos.org/manual/nix/stable/command-ref/nix-copy-closure.html) command.
You may also want to consider [dockerTools](#sec-pkgs-dockerTools) for your containerization needs.
:::

[]{#sec-pkgs-binary-cache-example}
:::{.example #ex-mkbinarycache-copying-package-closure}

# Copying a package and its closure to another machine with `mkBinaryCache`

The following derivation will construct a flat-file binary cache containing the closure of `hello`.

```nix
{ mkBinaryCache, hello }:
mkBinaryCache {
  rootPaths = [hello];
}
```

Build the cache on a machine.
Note that the command still builds the exact nix package above, but adds some boilerplate to build it directly from an expression.

```shellSession
$ nix-build -E 'let pkgs = import <nixpkgs> {}; in pkgs.callPackage ({ mkBinaryCache, hello }: mkBinaryCache { rootPaths = [hello]; }) {}'
/nix/store/azf7xay5xxdnia4h9fyjiv59wsjdxl0g-binary-cache
```

Copy the resulting directory to another machine, which we'll call `host2`:

```shellSession
$ scp result host2:/tmp/hello-cache
```

At this point, the cache can be used as a substituter when building derivations on `host2`:

```shellSession
$ nix-build -A hello '<nixpkgs>' \
  --option require-sigs false \
  --option trusted-substituters file:///tmp/hello-cache \
  --option substituters file:///tmp/hello-cache
/nix/store/zhl06z4lrfrkw5rp0hnjjfrgsclzvxpm-hello-2.12.1
```

:::
