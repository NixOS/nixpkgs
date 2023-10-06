# Meson {#meson}

Overrides the configure, check, and install phases to run `meson setup`, `meson test`, and `meson install`.

Meson is a meta-build system so you will need a secondary build system to run the generated build files in build phase. In Nixpkgs context, you will want to accompany Meson with ninja, which provides a [setup hook](#ninja) registering a ninja-based build phase.

By default, `enableParallelBuilding` is enabled as Meson supports parallel building almost everywhere.

## Variables controlling Meson {#variables-controlling-meson}

### `mesonFlags` {#mesonflags}

Controls the flags passed to `meson setup`.

##### `mesonCheckFlags` {#mesoncheckflags}

Controls the flags passed to `meson test`.

##### `mesonInstallFlags` {#mesoninstallflags}

Controls the flags passed to `meson install`.

### `mesonBuildType` {#mesonbuildtype}

Which [`--buildtype`](https://mesonbuild.com/Builtin-options.html#core-options) to pass to `meson setup`. We default to `plain`.

### `mesonAutoFeatures` {#mesonautofeatures}

What value to set [`-Dauto_features=`](https://mesonbuild.com/Builtin-options.html#core-options) to. We default to `enabled`.

### `mesonWrapMode` {#mesonwrapmode}

What value to set [`-Dwrap_mode=`](https://mesonbuild.com/Builtin-options.html#core-options) to. We default to `nodownload` as we disallow network access.

### `dontUseMesonConfigure` {#dontusemesonconfigure}

Disables using Meson’s `configurePhase`.

##### `dontUseMesonCheck` {#dontusemesoncheck}

Disables using Meson’s `checkPhase`.

##### `dontUseMesonInstall` {#dontusemesoninstall}

Disables using Meson’s `installPhase`.
