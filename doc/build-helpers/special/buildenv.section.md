# buildEnv {#sec-buildEnv}

`buildEnv` constructs a derivation containing directories and symbolic links,
which resembles the profile layout where a list of derivations or store paths are installed.

Unlike [`symlinkJoin`](#trivial-builder-symlinkJoin),
`buildEnv` takes special care of the outputs to link
and checks for content collisions across the paths by default.
Such functionalities make `buildEnv` suitable to construct environment wrappers such as an interpreter with modules or a program with extensions.
For example, [`python.withPackage`](#attributes-on-interpreters-packages) is based on `buildEnv`.

The constructed package's layout is considered an implementation detail of `buildEnv`,
which is not (necessarily) equivalent to that generated with `lndir` or constructed with `symlinkJoin`.

## Arguments {#sec-buildEnv-arguments}

`buildEnv` takes [fixed-point arguments (`buildEnv (finalAttrs: { })`)](#chap-build-helpers-finalAttrs) as well as a plain attribute set.

Unless otherwise noted, arguments can be overridden directly using [`<pkg>.overrideAttrs`](#sec-pkg-overrideAttrs).

`buildEnv` enforces [structured attributes (`{ __structuredAttrs = true; }`)](https://nix.dev/manual/nix/2.18/language/advanced-attributes.html#adv-attr-structuredAttrs).

- `name` or `pname` and `version` (required):
    The name of the environment.

- `paths` (required):
    The derivations or store paths to symlink ("install").

    Its element can be any path-like object that string-interpolates to a store path.
    The priority of each path is taken from `<path>.meta.priority`
    and falls back to `lib.meta.defaultPriority` if not set.

    The argument `paths` is passed as attribute `passthru.paths` to prevent unexpected context pollution.
    `passthru.paths` can be overridden with `<pkg>.overrideAttrs`.

-   `extraOutputsToInstall` (default to `[ ]`):
    The package outputs to include.
    By default, only the default output is included.

-   `extraPrefix` (default to `[ ]`):
    Root the result in directory `"$out${extraPrefix}"`, e.g. `"/share"`.

-   `ignoreCollisions` (default: `false`):
    Don't fail the build upon content collisions.

-   `checkCollisionContents` (default: `true`):
    If there is a collision,
    check whether the contents and permissions match;
    and only if not, throw a collision error.

-   `manifest` (default: `""`):
    The manifest file (if any).
    A symlink `$out/manifest` will be created to it.

-   `pathsToLink` (default: `[ "/" ]`):
    The paths (relative to each element of `paths`) that we want to symlink (e.g., `["/bin"]`).
    Any file not inside any of the directories in the list is not symlinked.

-   `postBuild` (default: `""`):
    Shell commands to run after building the symlink tree.

-   `derivationArgs` (default: `{ }`):
    Additional `stdenv.mkDerivation` arguments,
    such as `nativeBuildInputs`/`buildInputs` for `postBuild` dependencies and setup hooks.

    `derivationArgs` is not passed down to `stdenv.mkDerivation`.
    Override its attributes directly via `<pkg>.overrideAttrs` and reference directly via `finalAttrs`.
