# pkgs.mkBinaryCache {#sec-pkgs-binary-cache}

`pkgs.mkBinaryCache` is a function for creating Nix flat-file binary caches. Such a cache exists as a directory on disk, and can be used as a Nix substituter by passing `--substituter file:///path/to/cache` to Nix commands.

Nix packages are most commonly shared between machines using [HTTP, SSH, or S3](https://nixos.org/manual/nix/stable/package-management/sharing-packages.html), but a flat-file binary cache can still be useful in some situations. For example, you can copy it directly to another machine, or make it available on a network file system. It can also be a convenient way to make some Nix packages available inside a container via bind-mounting.

Note that this function is meant for advanced use-cases. The more idiomatic way to work with flat-file binary caches is via the [nix-copy-closure](https://nixos.org/manual/nix/stable/command-ref/nix-copy-closure.html) command. You may also want to consider [dockerTools](#sec-pkgs-dockerTools) for your containerization needs.

## Example {#sec-pkgs-binary-cache-example}

The following derivation will construct a flat-file binary cache containing the closure of `hello`.

```nix
mkBinaryCache {
  rootPaths = [hello];
}
```

- `rootPaths` specifies a list of root derivations. The transitive closure of these derivations' outputs will be copied into the cache.

Here's an example of building and using the cache.

Build the cache on one machine, `host1`:

```shellSession
nix-build -E 'with import <nixpkgs> {}; mkBinaryCache { rootPaths = [hello]; }'
```

```shellSession
/nix/store/cc0562q828rnjqjyfj23d5q162gb424g-binary-cache
```

Copy the resulting directory to the other machine, `host2`:

```shellSession
scp result host2:/tmp/hello-cache
```

Substitute the derivation using the flat-file binary cache on the other machine, `host2`:
```shellSession
nix-build -A hello '<nixpkgs>' \
  --option require-sigs false \
  --option trusted-substituters file:///tmp/hello-cache \
  --option substituters file:///tmp/hello-cache
```

```shellSession
/nix/store/gl5a41azbpsadfkfmbilh9yk40dh5dl0-hello-2.12.1
```
