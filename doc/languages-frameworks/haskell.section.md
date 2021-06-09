# Haskell {#haskell}

The Haskell infrastructure in nixpkgs has two main purposes: The
primary purpose is to provide a Haskell compiler and build tools
as well as infrastructure for packaging Haskell-based packages.

The secondary purpose is to provide support for Haskell development
environment including prebuilt Haskell libraries. However, in this
area sacrifices have been made due to self-imposed restrictions in
nixpkgs, to lessen the maintenance effort and improve performance.
Therefore it may be advantageous to use an alternative to the
Haskell infrastructure in nixpkgs for development environments in
many cases. The main limitations are that we only provide first-class
support for the default compiler (currently GHC 8.10.4) and usually
only provide a default and (if different) the latest version of
a haskell package.

## Available packages

The compiler and most build tools are exposed at the top level:

* `ghc` is the default version of GHC
* Language specific tools: `cabal-install`, `stack`, `hpack`, `alex`, `happy`, …

Many “normal” user facing packages written in Haskell, like `niv` or
`cachix`, are also exposed at the top level, so there is nothing
haskell specific to installing and using them.

All of these packages originally live in the `haskellPackages` package
set and are re-exposed with a reduced dependency closure for
convenience.

The `haskellPackages` set includes at least one version of every package
from hackage as well as some manually injected packages. This amounts to
a lot of packages, so it is hidden from `nix-env -qa` by default for
performance reasons. You can still list all packages in the set like
this, though:

```console
$ nix-env -f "<nixpkgs>" -qaP -A haskellPackages
haskellPackages.a50                                                         a50-0.5
haskellPackages.AAI                                                         AAI-0.2.0.1
haskellPackages.abacate                                                     abacate-0.0.0.0
haskellPackages.abc-puzzle                                                  abc-puzzle-0.2.1
haskellPackages.abcBridge                                                   abcBridge-0.15
…
```

The attribute names in `haskellPackages` always correspond with their
name on hackage. Since hackage allows names that are not valid nix
without extra escaping, you sometimes need to extra care when handling
attribute names like `3dmodels`.

For packages that are part of stackage, we use the version that is
currently part of [Stackage Nightly](https://www.stackage.org/nightly)
as the default version. For all other packages we use the latest
version from Hackage. Sometimes alternative versions of packages
are provided whose attribute names are their normal name with
their version appended after an underscore, e. g. `Cabal_3_4_0_0`.
If you are interested in details how the package set is populated,
read the section [Package set generation](#package-set-generation).

Most of the packages contained in `haskellPackages` don't actually
build and are marked as broken semi-automatically. Most of those
packages are deprecated or unmaintained, but sometimes packages
that should, don't build. Very often fixing them is not a lot of
work. How you can help with that is described in [Fixing a broken
package](#fixing-a-broken-package).

`haskellPackages` is built with our default compiler, but we also
provide other releases of GHC and package sets built with them.
You can list all available compilers like this:

```console
$ nix-env -f "<nixpkgs>" -qaP -A haskell.compiler
haskell.compiler.ghc8102Binary           ghc-8.10.2-binary
haskell.compiler.ghc8102BinaryMinimal    ghc-8.10.2-binary
haskell.compiler.ghc8104                 ghc-8.10.4
haskell.compiler.integer-simple.ghc8104  ghc-8.10.4
haskell.compiler.ghc865Binary            ghc-8.6.5-binary
haskell.compiler.ghc884                  ghc-8.8.4
haskell.compiler.integer-simple.ghc884   ghc-8.8.4
haskell.compiler.ghc901                  ghc-9.0.1
haskell.compiler.integer-simple.ghc901   ghc-9.0.1
haskell.compiler.ghcHEAD                 ghc-9.3.20210504
haskell.compiler.native-bignum.ghcHEAD   ghc-9.3.20210504
```

Every of those compilers has a corresponding attribute set built
completely using it. However, the non-standard package sets are
not tested regularly and have less working packages as a result.
The corresponding package set for GHC 9.0.1 is `haskell.packages.ghc901`
(in fact `haskellPackages` is just an alias for `haskell.packages.ghc8104`):

```console
$ nix-env -f "<nixpkgs>" -qaP -A haskell.packages.ghc901
haskell.packages.ghc901.a50                                                         a50-0.5
haskell.packages.ghc901.AAI                                                         AAI-0.2.0.1
haskell.packages.ghc901.abacate                                                     abacate-0.0.0.0
haskell.packages.ghc901.abc-puzzle                                                  abc-puzzle-0.2.1
haskell.packages.ghc901.abcBridge                                                   abcBridge-0.15
```

Every package set also re-exposes its GHC as `haskell.packages.*.ghc`.

## `haskellPackages.mkDerivation`

## Contributing

### Fixing a broken package {#fixing-a-broken-package}

### Package set generation {#package-set-generation}