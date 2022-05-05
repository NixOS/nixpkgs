# Testers {#chap-testers}
This chapter describes several testing builders which are available in the <literal>testers</literal> namespace.

## `testVersion` {#tester-testVersion}

Checks the command output contains the specified version

Although simplistic, this test assures that the main program
can run. While there's no substitute for a real test case,
it does catch dynamic linking errors and such. It also provides
some protection against accidentally building the wrong version,
for example when using an 'old' hash in a fixed-output derivation.

Examples:

```nix
passthru.tests.version = testVersion { package = hello; };

passthru.tests.version = testVersion {
  package = seaweedfs;
  command = "weed version";
};

passthru.tests.version = testVersion {
  package = key;
  command = "KeY --help";
  # Wrong '2.5' version in the code. Drop on next version.
  version = "2.5";
};
```

## `testEqualDerivation` {#tester-testEqualDerivation}

Checks that two packages produce the exact same build instructions.

This can be used to make sure that a certain difference of configuration,
such as the presence of an overlay does not cause a cache miss.

When the derivations are equal, the return value is an empty file.
Otherwise, the build log explains the difference via `nix-diff`.

Example:

```nix
testEqualDerivation
  "The hello package must stay the same when enabling checks."
  hello
  (hello.overrideAttrs(o: { doCheck = true; }))
```

## `invalidateFetcherByDrvHash` {#tester-invalidateFetcherByDrvHash}

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

```nix
tests.fetchgit = invalidateFetcherByDrvHash fetchgit {
  name = "nix-source";
  url = "https://github.com/NixOS/nix";
  rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
  sha256 = "sha256-7DszvbCNTjpzGRmpIVAWXk20P0/XTrWZ79KSOGLrUWY=";
};
```
