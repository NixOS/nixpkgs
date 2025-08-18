# buildEnv {#sec-buildEnv}

`buildEnv` constructs a derivation containing directories and symbolic links, which resembles the profile layout where a list of derivations or store paths are installed.

Unlike [`symlinkJoin`](#trivial-builder-symlinkJoin), `buildEnv` takes special care of the outputs to link and checks for content collisions across the paths by default.
A common use case for `buildEnv` is constructing environment wrappers, such as an interpreter with modules or a program with extensions.
For example, [`python.withPackage`](#attributes-on-interpreters-packages) is based on `buildEnv`.

## Arguments {#sec-buildEnv-arguments}

`buildEnv` takes [fixed-point arguments (`buildEnv (finalAttrs: { })`)](#chap-build-helpers-finalAttrs) as well as a plain attribute set.

Unless otherwise noted, arguments can be overridden directly using [`<pkg>.overrideAttrs`](#sec-pkg-overrideAttrs).

- `name` or `pname` and `version` (required):
    The name of the environment.

- `paths` (required):
    The derivations or store paths to symlink ("install").

    The elements can be any path-like object that string-interpolates to a store path.
    The priority of each path is taken from `<path>.meta.priority` and falls back to `lib.meta.defaultPriority` if not set.

    The argument `paths` is passed as attribute `passthru.paths` to prevent unexpected context pollution.
    `passthru.paths` can be overridden with `<pkg>.overrideAttrs`.

-   `extraOutputsToInstall` (default to `[ ]`):
    Package outputs to include in addition to what `meta.outputsToInstall` specifies.

-   `includeClosure` (default to `false`):
    Whether to include closures of all input paths.
    The list of the closure paths are constructed with `writeClosure`.
    They are installed with lower priority and with build-time exceptions silenced.

-   `extraPrefix` (default to `[ ]`):
    Root the result in directory `"$out${extraPrefix}"`, e.g. `"/share"`.

-   `ignoreCollisions` (default: `false`):
    Don't fail the build upon content collisions.

-   `checkCollisionContents` (default: `true`):
    If there is a collision, check whether the contents and permissions match; and only if not, throw a collision error.

-   `ignoreSingleFileOutputs` (default: `false`):
    Don't fail the build upon single-file outputs.

-   `manifest` (default: `""`):
    The manifest file (if any). A symlink `$out/manifest` will be created to it.

-   `pathsToLink` (default: `[ "/" ]`):
    The paths (relative to each element of `paths`) that we want to symlink (e.g., `["/bin"]`).
    Any file outside the directories in this list won't be symlinked into the produced environment.

-   `postBuild` (default: `""`):
    Shell commands to run after building the symlink tree.

-   `passthru` and `meta` (default: `{ }`):
    `stdenv.mkDerivation`-supported attributes not passing down to `builtins.derivation`.

-   `derivationArgs` (default: `{ }`):
    Additional `stdenv.mkDerivation` arguments, such as `nativeBuildInputs`/`buildInputs` for `postBuild` dependencies and setup hooks.

    `derivationArgs` is not passed down to `stdenv.mkDerivation`.
    Override its attributes directly via `<pkg>.overrideAttrs` and reference directly via `finalAttrs`.

## Build-time exceptions {#sec-buildEnv-exceptions}

There are situations where the specified `paths` might not produce sensible profile layout.
By default, the builder fails early upon detecting these exceptions.
`buildEnv` provides arguments to fine-tune or ignore certain exceptions.

### Path collisions {#ssec-buildEnv-collisions}

Path collisions occur when files provided by two more output paths with the same priority overlap with each other, making the result profile layout potentially affected by the order of elements of `paths`.
This is undesirable in several use cases, such as when `paths` are determined by merging Nix modules.

If the argument `checkCollisionContents` is `true`, the builder checks whether the overlapping paths share the same content and mode, and fails only if not.

The argument `ignoreCollisions` silence the collision checks and allow the files to be overwritten based on the order of chosen output paths.

In addition to silencing this exception with `ignoreCollisions`, one can also adjust the priority of colliding packages and store paths.
Store paths can specify priority in the form

```nix
{
  outPath = <path>;
  meta.priority = <priority>;
}
```

And [`lib.meta.setPrio`](#function-library-lib.meta.setPrio)-related Nixpkgs Library functions also apply to a string-like attribute set (`{ outPath = <path>; }`).

### Single-file outputs {#ssec-buildEnv-singleFileOutputs}

When an output path provides a single file instead of a directory, it inherently cannot merge into the result layout.
All discoverable packages should configure their `meta.outputsToInstall` correctly, so that single-file outputs won't be installed into a profile.

The `ignoreSingleFileOutputs` To drop all single-file output paths silently.
This option is useful when the specified paths contain the output paths of package tests.
