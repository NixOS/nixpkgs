# Rocq and rocq packages {#sec-language-rocq}

Note that "The Rocq Prover" (Rocq for short) is the new name of the
proof assistant formerly known as Coq. The `coq` and `coqPackages`
derivations currently remain for both older versions of Coq, but also
some versions of Rocq during the renaming transition. In the latter
case, the `coq` derivation encompasses the compatibility binaries
(`coqtop`, `coqc`, etc.) in addition to the `rocq` binary. The packages
only in `coqPackages` are the ones which currently still depend on these
compatibility binaries.

## Rocq derivation: `rocq-core` {#rocq-derivation-rocq}

The Rocq derivation is overridable through the `rocq-core.override overrides`, where overrides is an attribute set which contains the arguments to override. We recommend overriding either of the following:

* `version` (optional, defaults to the latest version of Rocq selected for nixpkgs, see `pkgs/top-level/rocq-packages` to witness this choice), which follows the conventions explained in the `rocqPackages` section below,
* `customOCamlPackages` (optional, defaults to `null`, which lets Rocq choose a version automatically), which can be set to any of the ocaml packages attribute of `ocaml-ng` (such as `ocaml-ng.ocamlPackages_4_14` which is the default for Rocq 9.1 for example).
* `rocq-version` (optional, defaults to the short version e.g. "9.1"), is a version number of the form "x.y" that indicates which Rocq's version build behavior to mimic when using a source which is not a release. E.g. `rocq-core.override { version = "40be8435e132aab2231a79091f011ebc3e64a753"; rocq-version = "9.1"; }`.

## Creating custom Coq environments with `coq.withPackages` {#coq-withPackages}

The `coq.withPackages` function provides a convenient way to create a Coq environment that includes additional Coq packages. This is similar to how `python.withPackages` works for Python environments.

The function takes a function that receives the Coq package set and returns a list of packages. It returns a wrapped Coq environment where all Coq binaries (`coqtop`, `coqc`, `coqdep`, `coqchk`, `coqide`, etc.) are configured with the appropriate environment variables to find the packages.

### Usage {#coq-withPackages-usage}

Here is an example of creating a Coq environment with specific packages.

```nix
coq.withPackages (
  ps: with ps; [
    mathcomp
    bignums
  ]
)
```

## Rocq packages attribute sets: `rocqPackages` {#rocq-packages-attribute-sets-rocqpackages}

The recommended way of defining a derivation for a Rocq library, is to use the `rocqPackages.mkRocqDerivation` function, which is essentially a specialization of `mkDerivation` taking into account most of the specifics of Rocq libraries. The following attributes are supported:

* `pname` (required) is the name of the package,
* `version` (optional, defaults to `null`), is the version to fetch and build,
  this attribute is interpreted in several ways depending on its type and pattern:
  * if it is a known released version string, i.e. from the `release` attribute below, the according release is picked, and the `version` attribute of the resulting derivation is set to this release string,
  * if it is a majorMinor `"x.y"` prefix of a known released version (as defined above), then the latest `"x.y.z"` known released version is selected (for the ordering given by `versionAtLeast`),
  * if it is a path or a string representing an absolute path (i.e. starting with `"/"`), the provided path is selected as a source, and the `version` attribute of the resulting derivation is set to `"dev"`,
  * if it is a string of the form `owner:branch` then it tries to download the `branch` of owner `owner` for a project of the same name using the same vcs, and the `version` attribute of the resulting derivation is set to `"dev"`, additionally if the owner is not provided (i.e. if the `owner:` prefix is missing), it defaults to the original owner of the package (see below),
  * if it is a string of the form `"#N"`, and the domain is github, then it tries to download the current head of the pull request `#N` from github,
* `defaultVersion` (optional). Rocq libraries may be compatible with some specific versions of Rocq only. The `defaultVersion` attribute is used when no `version` is provided (or if `version = null`) to select the version of the library to use by default, depending on the context. This selection will mainly depend on a `rocq-core` version number but also possibly on other packages versions (e.g. `mathcomp`). If its value ends up to be `null`, the package is marked for removal in end-user `rocqPackages` attribute set.
* `release` (optional, defaults to `{}`), lists all the known releases of the library and for each of them provides an attribute set with at least a `hash` attribute (you may put the empty string `""` in order to automatically insert a fake hash, this will trigger an error which will allow you to find the correct hash), each attribute set of the list of releases also takes optional overloading arguments for the fetcher as below (i.e.`domain`, `owner`, `repo`, `rev`, `artifact` assuming the default fetcher is used) and optional overrides for the result of the fetcher (i.e. `version` and `src`).
* `fetcher` (optional, defaults to a generic fetching mechanism supporting github or gitlab based infrastructures), is a function that takes at least an `owner`, a `repo`, a `rev`, and a `hash` and returns an attribute set with a `version` and `src`.
* `repo` (optional, defaults to the value of `pname`),
* `owner` (optional, defaults to `"rocq-community"`).
* `domain` (optional, defaults to `"github.com"`), domains including the strings `"github"` or `"gitlab"` in their names are automatically supported, otherwise, one must change the `fetcher` argument to support them (cf `pkgs/development/rocq-modules/bignums/default.nix` for an example),
* `releaseRev` (optional, defaults to `(v: v)`), provides a default mapping from release names to revision hashes/branch names/tags,
* `releaseArtifact` (optional, defaults to `(v: null)`), provides a default mapping from release names to artifact names (only works for github artifact for now),
* `displayVersion` (optional), provides a way to alter the computation of `name` from `pname`, by explaining how to display version numbers,
* `namePrefix` (optional, defaults to `[ "rocq-core" ]`), provides a way to alter the computation of `name` from `pname`, by explaining which dependencies must occur in `name`,
* `nativeBuildInputs` (optional), is a list of executables that are required to build the current derivation, in addition to the default ones (namely `which`, `dune` and `ocaml` depending on whether `useDune`, `useDuneifVersion` and `mlPlugin` are set).
* `extraNativeBuildInputs` (optional, deprecated), an additional list of derivation to add to `nativeBuildInputs`,
* `overrideNativeBuildInputs` (optional) replaces the default list of derivation to which `nativeBuildInputs` and `extraNativeBuildInputs` adds extra elements,
* `buildInputs` (optional), is a list of libraries and dependencies that are required to build and run the current derivation, in addition to the default one `[ rocq-core ]`,
* `extraBuildInputs` (optional, deprecated), an additional list of derivation to add to `buildInputs`,
* `overrideBuildInputs` (optional) replaces the default list of derivation to which `buildInputs` and `extraBuildInputs` adds extras elements,
* `propagatedBuildInputs` (optional) is passed as is to `mkDerivation`, we recommend to use this for Rocq libraries and Rocq plugin dependencies, as this makes sure the paths of the compiled libraries and plugins will always be added to the build environments of subsequent derivation, which is necessary for Rocq packages to work correctly,
* `mlPlugin` (optional, defaults to `false`). Some extensions (plugins) might require OCaml and sometimes other OCaml packages. Standard dependencies can be added by setting the current option to `true`. For a finer grain control, the `rocq-core.ocamlPackages` attribute can be used in `nativeBuildInputs`, `buildInputs`, and `propagatedBuildInputs` to depend on the same package set Rocq was built against.
* `useDuneifVersion` (optional, default to `(x: false)` uses Dune to build the package if the provided predicate evaluates to true on the version, e.g. `useDuneifVersion = versions.isGe "1.1"`  will use dune if the version of the package is greater or equal to `"1.1"`,
* `useDune` (optional, defaults to `false`) uses Dune to build the package if set to true, the presence of this attribute overrides the behavior of the previous one.
* `opam-name` (optional, defaults to concatenating with a dash separator the components of `namePrefix` and `pname`), name of the Dune package to build.
* `enableParallelBuilding` (optional, defaults to `true`), since it is activated by default, we provide a way to disable it.
* `extraInstallFlags` (optional), allows to extend `installFlags` which initializes the variables `COQLIBINSTALL` and `COQPLUGININSTALL` so as to install in the proper subdirectory. Indeed Rocq libraries should be installed in `$(out)/lib/coq/${rocq-core.rocq-version}/user-contrib/`. Such directories are automatically added to the `$ROCQPATH` environment variable by the hook defined in the Rocq derivation.
* `setROCQBIN` (optional, defaults to `true`), by default, the environment variable `$ROCQBIN` is set to the current Rocq's binary, but one can disable this behavior by setting it to `false`,
* `useMelquiondRemake` (optional, default to `null`) is an attribute set, which, if given, overloads the `preConfigurePhases`, `configureFlags`, `buildPhase`, and `installPhase` attributes of the derivation for a specific use in libraries using `remake` as set up by Guillaume Melquiond for `flocq`, `gappalib`, `interval`, and `coquelicot` (see the corresponding derivation for concrete examples of use of this option). For backward compatibility, the attribute `useMelquiondRemake.logpath` must be set to the logical root of the library (otherwise, one can pass `useMelquiondRemake = {}` to activate this without backward compatibility).
* `dropAttrs`, `keepAttrs`, `dropDerivationAttrs` are all optional and allow to tune which attribute is added or removed from the final call to `mkDerivation`.

It also takes other standard `mkDerivation` attributes, they are added as such, except for `meta` which extends an automatically computed `meta` (where the `platform` is the same as `rocq-core` and the homepage is automatically computed).

Here is a simple package example. It is a pure Rocq library, thus it depends on Rocq. It builds on the Mathematical Components library, thus it also takes some `mathcomp` derivations as `extraBuildInputs`.

```nix
{
  lib,
  mkRocqDerivation,
  version ? null,
  rocq-core,
  mathcomp,
  mathcomp-finmap,
  mathcomp-bigenough,
}:

mkRocqDerivation {
  # namePrefix leads to e.g. `name = rocq-core9.1-mathcomp2.5.0-multinomials-2.4.0`
  namePrefix = [
    "rocq-core"
    "mathcomp"
  ];
  pname = "multinomials";
  owner = "math-comp";
  inherit version;
  defaultVersion =
    let
      case = rocq: mc: out: {
        cases = [
          rocq-core
          mc
        ];
        inherit out;
      };
    in
    with lib.versions;
    lib.switch
      [ rocq-core.rocq-version mathcomp.version ]
      [
        (case (range "8.18" "9.1") (range "2.1.0" "2.5.0") "2.4.0")
        (case (range "8.17" "9.0") (range "2.1.0" "2.3.0") "2.3.0")
      ]
      null;
  release = {
    "2.4.0".sha256 = "sha256-7zfIddRH+Sl4nhEPtS/lMZwRUZI45AVFpcC/UC8Z0Yo=";
    "2.3.0".sha256 = "sha256-usIcxHOAuN+f/j3WjVbPrjz8Hl9ac8R6kYeAKi3CEts=";
  };

  propagatedBuildInputs = [
    mathcomp.boot
    mathcomp.algebra
    mathcomp-finmap
    mathcomp.fingroup
    mathcomp-bigenough
  ];

  meta = {
    description = "Coq/SSReflect Library for Monoidal Rings and Multinomials";
    license = lib.licenses.cecill-c;
  };
}
```

## Three ways of overriding Rocq packages {#rocq-overriding-packages}

There are three distinct ways of changing a Rocq package by overriding one of its values: `.override`, `overrideRocqDerivation`, and `.overrideAttrs`.  This section explains what sort of values can be overridden with each of these methods.

### `.override` {#rocq-override}

`.override` lets you change arguments to a Rocq derivation.  In the case of the `multinomials` package above, `.override` would let you override arguments like `mkRocqDerivation`, `version`, `rocq-core`, `mathcomp`, `mathcom-finmap`, etc.

For example, assuming you have a special `mathcomp` dependency you want to use, here is how you could override the `mathcomp` dependency:

```nix
multinomials.override { mathcomp = my-special-mathcomp; }
```

In Nixpkgs, all Rocq derivations take a `version` argument.  This can be overridden in order to easily use a different version:

```nix
rocqPackages.multinomials.override { version = "1.5.1"; }
```

Refer to [](#rocq-packages-attribute-sets-rocqpackages) for all the different formats that you can potentially pass to `version`, as well as the restrictions.

### `overrideRocqDerivation` {#rocq-overrideRocqDerivation}

The `overrideRocqDerivation` function lets you easily change arguments to `mkRocqDerivation`.  These arguments are described in [](#rocq-packages-attribute-sets-rocqpackages).

For example, here is how you could locally add a new release of the `multinomials` library, and set the `defaultVersion` to use this release:

```nix
rocqPackages.lib.overrideRocqDerivation {
  defaultVersion = "2.0";
  release."2.0".hash = "sha256-czoP11rtrIM7+OLdMisv2EF7n/IbGuwFxHiPtg3qCNM=";
} rocqPackages.multinomials
```

### `.overrideAttrs` {#rocq-overrideAttrs}

`.overrideAttrs` lets you override arguments to the underlying `stdenv.mkDerivation` call. Internally, `mkRocqDerivation` uses `stdenv.mkDerivation` to create derivations for Rocq libraries.  You can override arguments to `stdenv.mkDerivation` with `.overrideAttrs`.

For instance, here is how you could add some code to be performed in the derivation after installation is complete:

```nix
rocqPackages.multinomials.overrideAttrs (oldAttrs: {
  postInstall = oldAttrs.postInstall or "" + ''
    echo "you can do anything you want here"
  '';
})
```
