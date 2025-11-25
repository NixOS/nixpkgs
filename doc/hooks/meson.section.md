# Meson {#meson}

[Meson](https://mesonbuild.com/) is an open source meta build system meant to be
fast and user-friendly.

In Nixpkgs, meson comes with a setup hook that overrides the configure, check,
and install phases.

Being a meta build system, meson needs an accompanying backend. In the context
of Nixpkgs, the typical companion backend is [Ninja](#ninja), that provides a
setup hook registering ninja-based build and install phases.

## Variables controlling Meson {#meson-variables-controlling}

### Meson Exclusive Variables {#meson-exclusive-variables}

#### `mesonFlags` {#meson-flags}

Controls the flags passed to `meson setup` during configure phase.

#### `mesonBuildDir` {#meson-build-dir}

Directory where Meson will put intermediate files.

Setting this can be useful for debugging multiple Meson builds while in the same source directory, for example, when building for different platforms.
Different values for each build will prevent build artifacts from interfering with each other.
This setting has no tangible effect when running the build in a sandboxed derivation.

The default value is `build`.

#### `mesonWrapMode` {#meson-wrap-mode}

Which value is passed as
[`-Dwrap_mode=`](https://mesonbuild.com/Builtin-options.html#core-options).
In Nixpkgs, the default value is `nodownload`, so that no subproject will be
downloaded (since network access is already disabled during deployment in
Nixpkgs).

Note: Meson allows pre-population of subprojects that would otherwise be
downloaded.

#### `mesonBuildType` {#meson-build-type}

Which value is passed as
[`--buildtype`](https://mesonbuild.com/Builtin-options.html#core-options) to
`meson setup` during configure phase. In Nixpkgs, the default value is `plain`.

#### `mesonAutoFeatures` {#meson-auto-features}

Which value is passed as
[`-Dauto_features=`](https://mesonbuild.com/Builtin-options.html#core-options)
to `meson setup` during configure phase. In Nixpkgs, the default value is
`enabled`, meaning that every feature declared as "auto" by the meson scripts
will be enabled.

#### `mesonCheckFlags` {#meson-check-flags}

Controls the flags passed to `meson test` during check phase.

#### `mesonInstallFlags` {#meson-install-flags}

Controls the flags passed to `meson install` during install phase.

#### `mesonInstallTags` {#meson-install-tags}

A list of installation tags passed to Meson's commandline option
[`--tags`](https://mesonbuild.com/Installing.html#installation-tags) during
install phase.

Note: `mesonInstallTags` should be a list of strings that will be converted to
a comma-separated string that is recognized to `--tags`.
Example: `mesonInstallTags = [ "emulator" "assembler" ];` will be converted to
`--tags emulator,assembler`.

#### `dontUseMesonConfigure` {#dont-use-meson-configure}

When set to true, don't use the predefined `mesonConfigurePhase`.

#### `dontUseMesonCheck` {#dont-use-meson-check}

When set to true, don't use the predefined `mesonCheckPhase`.

#### `dontUseMesonInstall` {#dont-use-meson-install}

When set to true, don't use the predefined `mesonInstallPhase`.

### Honored variables {#meson-honored-variables}

The following variables commonly used by `stdenv.mkDerivation` are honored by
Meson setup hook.

- `prefixKey`
- `enableParallelBuilding`
- `enableParallelChecking`
