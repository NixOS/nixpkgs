# ninja {#ninja}

[Ninja](https://ninja-build.org/) is a small build system with focused on speed.

In nixpkgs, `ninja` comes with a hook that overrides the default build, install,
and check phases.

Note that if the [Meson setup hook](#meson) is also active, Meson install and
check phases will take precedence over Ninja ones.

## Variables controlling ninja hook {#ninja-variables-controlling}

### Exclusive Variables {#ninja-exclusive-variables}

The variables below are exclusive of `ninja` hook.

#### `ninjaEnableVerboseOutput` {#ninja-enable-verbose-output}

Adds `--verbose` to Ninja invocations, effectively showing the complete command
line of each command invoked by Ninja.

#### `ninjaFlags` {#ninja-flags}

Controls the flags passed to ninja tool during build, install and check phases.

#### `dontUseNinjaBuild` {#dont-use-ninja-build}

When set to true, don't use the predefined `ninjaBuildPhase`.

#### `dontUseNinjaInstall` {#dont-use-ninja-install}

When set to true, don't use the predefined `ninjaInstallPhase`.

#### `dontUseNinjaCheck` {#dont-use-ninja-check}

When set to true, don't use the predefined `ninjaCheckPhase`.

### Honored variables {#ninja-honored-variables}

The following variables commonly used by `stdenv.mkDerivation` are honored by
`ninja` hook.

- `enableParallelBuilding`
- `enableParallelInstalling`
- `checkTarget`
- `installTargets`
