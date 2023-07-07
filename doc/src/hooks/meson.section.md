# Meson {#meson}

Overrides the configure phase to run meson to generate Ninja files. To run these files, you should accompany Meson with ninja. By default, `enableParallelBuilding` is enabled as Meson supports parallel building almost everywhere.

## Variables controlling Meson {#variables-controlling-meson}

### `mesonFlags` {#mesonflags}

Controls the flags passed to meson.

### `mesonBuildType` {#mesonbuildtype}

Which [`--buildtype`](https://mesonbuild.com/Builtin-options.html#core-options) to pass to Meson. We default to `plain`.

### `mesonAutoFeatures` {#mesonautofeatures}

What value to set [`-Dauto_features=`](https://mesonbuild.com/Builtin-options.html#core-options) to. We default to `enabled`.

### `mesonWrapMode` {#mesonwrapmode}

What value to set [`-Dwrap_mode=`](https://mesonbuild.com/Builtin-options.html#core-options) to. We default to `nodownload` as we disallow network access.

### `dontUseMesonConfigure` {#dontusemesonconfigure}

Disables using Meson’s `configurePhase`.
