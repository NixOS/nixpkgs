# Coq and coq packages {#sec-language-coq}

## Coq derivation: `coq` {#coq-derivation-coq}

The Coq derivation is overridable through the `coq.override overrides`, where overrides is an attribute set which contains the arguments to override. We recommend overriding either of the following

* `version` (optional, defaults to the latest version of Coq selected for nixpkgs, see `pkgs/top-level/coq-packages` to witness this choice), which follows the conventions explained in the `coqPackages` section below,
* `customOCamlPackages` (optional, defaults to `null`, which lets Coq choose a version automatically), which can be set to any of the ocaml packages attribute of `ocaml-ng` (such as `ocaml-ng.ocamlPackages_4_10` which is the default for Coq 8.11 for example).
* `coq-version` (optional, defaults to the short version e.g. "8.10"), is a version number of the form "x.y" that indicates which Coq's version build behavior to mimic when using a source which is not a release. E.g. `coq.override { version = "d370a9d1328a4e1cdb9d02ee032f605a9d94ec7a"; coq-version = "8.10"; }`.

The associated package set can be obtained using `mkCoqPackages coq`, where `coq` is the derivation to use.

## Coq packages attribute sets: `coqPackages` {#coq-packages-attribute-sets-coqpackages}

The recommended way of defining a derivation for a Coq library, is to use the `coqPackages.mkCoqDerivation` function, which is essentially a specialization of `mkDerivation` taking into account most of the specifics of Coq libraries. The following attributes are supported:

* `pname` (required) is the name of the package,
* `version` (optional, defaults to `null`), is the version to fetch and build,
  this attribute is interpreted in several ways depending on its type and pattern:
  * if it is a known released version string, i.e. from the `release` attribute below, the according release is picked, and the `version` attribute of the resulting derivation is set to this release string,
  * if it is a majorMinor `"x.y"` prefix of a known released version (as defined above), then the latest `"x.y.z"` known released version is selected (for the ordering given by `versionAtLeast`),
  * if it is a path or a string representing an absolute path (i.e. starting with `"/"`), the provided path is selected as a source, and the `version` attribute of the resulting derivation is set to `"dev"`,
  * if it is a string of the form `owner:branch` then it tries to download the `branch` of owner `owner` for a project of the same name using the same vcs, and the `version` attribute of the resulting derivation is set to `"dev"`, additionally if the owner is not provided (i.e. if the `owner:` prefix is missing), it defaults to the original owner of the package (see below),
  * if it is a string of the form `"#N"`, and the domain is github, then it tries to download the current head of the pull request `#N` from github,
* `defaultVersion` (optional). Coq libraries may be compatible with some specific versions of Coq only. The `defaultVersion` attribute is used when no `version` is provided (or if `version = null`) to select the version of the library to use by default, depending on the context. This selection will mainly depend on a `coq` version number but also possibly on other packages versions (e.g. `mathcomp`). If its value ends up to be `null`, the package is marked for removal in end-user `coqPackages` attribute set.
* `release` (optional, defaults to `{}`), lists all the known releases of the library and for each of them provides an attribute set with at least a `hash` attribute (you may put the empty string `""` in order to automatically insert a fake hash, this will trigger an error which will allow you to find the correct hash), each attribute set of the list of releases also takes optional overloading arguments for the fetcher as below (i.e.`domain`, `owner`, `repo`, `rev` assuming the default fetcher is used) and optional overrides for the result of the fetcher (i.e. `version` and `src`).
* `fetcher` (optional, defaults to a generic fetching mechanism supporting github or gitlab based infrastructures), is a function that takes at least an `owner`, a `repo`, a `rev`, and a `hash` and returns an attribute set with a `version` and `src`.
* `repo` (optional, defaults to the value of `pname`),
* `owner` (optional, defaults to `"coq-community"`).
* `domain` (optional, defaults to `"github.com"`), domains including the strings `"github"` or `"gitlab"` in their names are automatically supported, otherwise, one must change the `fetcher` argument to support them (cf `pkgs/development/coq-modules/heq/default.nix` for an example),
* `releaseRev` (optional, defaults to `(v: v)`), provides a default mapping from release names to revision hashes/branch names/tags,
* `displayVersion` (optional), provides a way to alter the computation of `name` from `pname`, by explaining how to display version numbers,
* `namePrefix` (optional, defaults to `[ "coq" ]`), provides a way to alter the computation of `name` from `pname`, by explaining which dependencies must occur in `name`,
* `nativeBuildInputs` (optional), is a list of executables that are required to build the current derivation, in addition to the default ones (namely `which`, `dune` and `ocaml` depending on whether `useDune`, `useDuneifVersion` and `mlPlugin` are set).
* `extraNativeBuildInputs` (optional, deprecated), an additional list of derivation to add to `nativeBuildInputs`,
* `overrideNativeBuildInputs` (optional) replaces the default list of derivation to which `nativeBuildInputs` and `extraNativeBuildInputs` adds extra elements,
* `buildInputs` (optional), is a list of libraries and dependencies that are required to build and run the current derivation, in addition to the default one `[ coq ]`,
* `extraBuildInputs` (optional, deprecated), an additional list of derivation to add to `buildInputs`,
* `overrideBuildInputs` (optional) replaces the default list of derivation to which `buildInputs` and `extraBuildInputs` adds extras elements,
* `propagatedBuildInputs` (optional) is passed as is to `mkDerivation`, we recommend to use this for Coq libraries and Coq plugin dependencies, as this makes sure the paths of the compiled libraries and plugins will always be added to the build environments of subsequent derivation, which is necessary for Coq packages to work correctly,
* `mlPlugin` (optional, defaults to `false`). Some extensions (plugins) might require OCaml and sometimes other OCaml packages. Standard dependencies can be added by setting the current option to `true`. For a finer grain control, the `coq.ocamlPackages` attribute can be used in `nativeBuildInputs`, `buildInputs`, and `propagatedBuildInputs` to depend on the same package set Coq was built against.
* `useDuneifVersion` (optional, default to `(x: false)` uses Dune to build the package if the provided predicate evaluates to true on the version, e.g. `useDuneifVersion = versions.isGe "1.1"`  will use dune if the version of the package is greater or equal to `"1.1"`,
* `useDune` (optional, defaults to `false`) uses Dune to build the package if set to true, the presence of this attribute overrides the behavior of the previous one.
* `opam-name` (optional, defaults to concatenating with a dash separator the components of `namePrefix` and `pname`), name of the Dune package to build.
* `enableParallelBuilding` (optional, defaults to `true`), since it is activated by default, we provide a way to disable it.
* `extraInstallFlags` (optional), allows to extend `installFlags` which initializes the variable `COQMF_COQLIB` so as to install in the proper subdirectory. Indeed Coq libraries should be installed in `$(out)/lib/coq/${coq.coq-version}/user-contrib/`. Such directories are automatically added to the `$COQPATH` environment variable by the hook defined in the Coq derivation.
* `setCOQBIN` (optional, defaults to `true`), by default, the environment variable `$COQBIN` is set to the current Coq's binary, but one can disable this behavior by setting it to `false`,
* `useMelquiondRemake` (optional, default to `null`) is an attribute set, which, if given, overloads the `preConfigurePhases`, `configureFlags`, `buildPhase`, and `installPhase` attributes of the derivation for a specific use in libraries using `remake` as set up by Guillaume Melquiond for `flocq`, `gappalib`, `interval`, and `coquelicot` (see the corresponding derivation for concrete examples of use of this option). For backward compatibility, the attribute `useMelquiondRemake.logpath` must be set to the logical root of the library (otherwise, one can pass `useMelquiondRemake = {}` to activate this without backward compatibility).
* `dropAttrs`, `keepAttrs`, `dropDerivationAttrs` are all optional and allow to tune which attribute is added or removed from the final call to `mkDerivation`.

It also takes other standard `mkDerivation` attributes, they are added as such, except for `meta` which extends an automatically computed `meta` (where the `platform` is the same as `coq` and the homepage is automatically computed).

Here is a simple package example. It is a pure Coq library, thus it depends on Coq. It builds on the Mathematical Components library, thus it also takes some `mathcomp` derivations as `extraBuildInputs`.

```nix
{ lib, mkCoqDerivation, version ? null
, coq, mathcomp, mathcomp-finmap, mathcomp-bigenough }:

mkCoqDerivation {
  /* namePrefix leads to e.g. `name = coq8.11-mathcomp1.11-multinomials-1.5.2` */
  namePrefix = [ "coq" "mathcomp" ];
  pname = "multinomials";
  owner = "math-comp";
  inherit version;
  defaultVersion = with lib.versions; lib.switch [ coq.version mathcomp.version ] [
      { cases = [ (range "8.7" "8.12") (isEq "1.11") ];        out = "1.5.2"; }
      { cases = [ (range "8.7" "8.11") (range "1.8" "1.10") ]; out = "1.5.0"; }
      { cases = [ (range "8.7" "8.10") (range "1.8" "1.10") ]; out = "1.4"; }
      { cases = [ (isEq "8.6")         (range "1.6" "1.7") ];  out = "1.1"; }
    ] null;
  release = {
    "1.5.2".hash = "sha256-mjCx9XKa38Nz9E6wNK7YSqHdJ7YTua5fD3d6J4e7WpU=";
    "1.5.1".hash = "sha256-Q8tm0y2FQAt2V1kZYkDlHWRia/lTvXAMVjdmzEV11I4=";
    "1.5.0".hash = "sha256-HIK0f21G69oEW8JG46gSBde/Q2LR3GiBCv680gHbmRg=";
    "1.5.0".rev  = "1.5";
    "1.4".hash   = "sha256-F9g3MSIr3B6UZ3p8QWjz3/Jpw9sudJ+KRlvjiHSO024=";
    "1.3".hash   = "sha256-BPJTlAL0ETHvLMBslE0KFVt3DNoaGuMrHt2SBGyJe1A=";
    "1.2".hash   = "sha256-mHXBXSLYO4BN+jfN50y/+XCx0Qq5g4Ac2Y/qlsbgAdY=";
    "1.1".hash   = "sha256-ejAsMQbB/LtU9j+g160VdGXULrCe9s0gBWzyhKqmCuE=";
    "1.0".hash   = "sha256-tZTOltEBBKWciDxDMs/Ye4Jnq/33CANrHJ4FBMPtq+I=";
  };

  propagatedBuildInputs =
    [ mathcomp.ssreflect mathcomp.algebra mathcomp-finmap mathcomp-bigenough ];

  meta = {
    description = "Coq/SSReflect Library for Monoidal Rings and Multinomials";
    license = lib.licenses.cecill-c;
  };
}
```

## Three ways of overriding Coq packages {#coq-overriding-packages}

There are three distinct ways of changing a Coq package by overriding one of its values: `.override`, `overrideCoqDerivation`, and `.overrideAttrs`.  This section explains what sort of values can be overridden with each of these methods.

### `.override` {#coq-override}

`.override` lets you change arguments to a Coq derivation.  In the case of the `multinomials` package above, `.override` would let you override arguments like `mkCoqDerivation`, `version`, `coq`, `mathcomp`, `mathcom-finmap`, etc.

For example, assuming you have a special `mathcomp` dependency you want to use, here is how you could override the `mathcomp` dependency:

```nix
multinomials.override {
  mathcomp = my-special-mathcomp;
}
```

In Nixpkgs, all Coq derivations take a `version` argument.  This can be overridden in order to easily use a different version:

```nix
coqPackages.multinomials.override {
  version = "1.5.1";
}
```

Refer to [](#coq-packages-attribute-sets-coqpackages) for all the different formats that you can potentially pass to `version`, as well as the restrictions.

### `overrideCoqDerivation` {#coq-overrideCoqDerivation}

The `overrideCoqDerivation` function lets you easily change arguments to `mkCoqDerivation`.  These arguments are described in [](#coq-packages-attribute-sets-coqpackages).

For example, here is how you could locally add a new release of the `multinomials` library, and set the `defaultVersion` to use this release:

```nix
coqPackages.lib.overrideCoqDerivation
  {
    defaultVersion = "2.0";
    release."2.0".hash = "sha256-czoP11rtrIM7+OLdMisv2EF7n/IbGuwFxHiPtg3qCNM=";
  }
  coqPackages.multinomials
```

### `.overrideAttrs` {#coq-overrideAttrs}

`.overrideAttrs` lets you override arguments to the underlying `stdenv.mkDerivation` call. Internally, `mkCoqDerivation` uses `stdenv.mkDerivation` to create derivations for Coq libraries.  You can override arguments to `stdenv.mkDerivation` with `.overrideAttrs`.

For instance, here is how you could add some code to be performed in the derivation after installation is complete:

```nix
coqPackages.multinomials.overrideAttrs (oldAttrs: {
  postInstall = oldAttrs.postInstall or "" + ''
    echo "you can do anything you want here"
  '';
})
```
