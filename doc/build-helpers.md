# Build helpers {#part-builders}

A build helper is a function that produces derivations.

:::{.warning}
This is not to be confused with the [`builder` argument of the Nix `derivation` primitive](https://nixos.org/manual/nix/unstable/language/derivations.html), which refers to the executable that produces the build result, or [remote builder](https://nixos.org/manual/nix/stable/advanced-topics/distributed-builds.html), which refers to a remote  machine that could run such an executable.
:::

Such a function is usually designed to abstract over a typical workflow for a given programming language or framework.
This allows declaring a build recipe by setting a limited number of options relevant to the particular use case instead of using the `derivation` function directly.

[`stdenv.mkDerivation`](#part-stdenv) is the most widely used build helper, and serves as a basis for many others.
In addition, it offers various options to customize parts of the builds.

There is no uniform interface for build helpers.
[Trivial build helpers](#chap-trivial-builders) and [fetchers](#chap-pkgs-fetchers) have various input types for convenience.
[Language- or framework-specific build helpers](#chap-language-support) usually follow the style of `stdenv.mkDerivation`, which accepts an attribute set or a fixed-point function taking an attribute set.

```{=include=} chapters
build-helpers/fixed-point-arguments.chapter.md
build-helpers/fetchers.chapter.md
build-helpers/trivial-build-helpers.chapter.md
build-helpers/testers.chapter.md
build-helpers/dev-shell-tools.chapter.md
build-helpers/special.md
build-helpers/images.md
hooks/index.md
languages-frameworks/index.md
packages/index.md
```
