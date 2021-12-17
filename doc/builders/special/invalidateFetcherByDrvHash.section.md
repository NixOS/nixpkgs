
## `invalidateFetcherByDrvHash` {#sec-pkgs-invalidateFetcherByDrvHash}

Use the derivation hash to invalidate the output via name, for testing.

Type: `(a@{ name, ... } -> Derivation) -> a -> Derivation`

Normally, fixed output derivations can and should be cached by their output
hash only, but for testing we want to re-fetch everytime the fetcher changes.

Changes to the fetcher become apparent in the drvPath, which is a hash of
how to fetch, rather than a fixed store path.
By inserting this hash into the name, we can make sure to re-run the fetcher
every time the fetcher changes.

This relies on the assumption that Nix isn't clever enough to reuse its
database of local store contents to optimize fetching.

You might notice that the "salted" name derives from the normal invocation,
not the final derivation. `invalidateFetcherByDrvHash` has to invoke the fetcher
function twice: once to get a derivation hash, and again to produce the final
fixed output derivation.

Example:

    tests.fetchgit = invalidateFetcherByDrvHash fetchgit {
      name = "nix-source";
      url = "https://github.com/NixOS/nix";
      rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
      sha256 = "sha256-7DszvbCNTjpzGRmpIVAWXk20P0/XTrWZ79KSOGLrUWY=";
    };
