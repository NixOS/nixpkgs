# wafHook {#waf-hook}

[Waf](https://waf.io) is a Python-based software building system.

In Nixpkgs, `wafHook` overrides the default configure, build, and install phases.

## Variables controlling wafHook {#waf-hook-variables-controlling}

### `wafHook` Exclusive Variables {#waf-hook-exclusive-variables}

The variables below are exclusive of `wafHook`.

#### `wafPath` {#waf-path}

Location of the `waf` tool. It defaults to `./waf`, to honor software projects that include it directly inside their source trees.

If `wafPath` doesn't exist, then `wafHook` will copy the `waf` provided from Nixpkgs to it.

#### `wafFlags` {#waf-flags}

Controls the flags passed to waf tool during build and install phases. For settings specific to build or install phases, use `wafBuildFlags` or `wafInstallFlags` respectively.

#### `dontUseWafConfigure` {#dont-use-waf-configure}

When set to true, don't use the predefined `wafConfigurePhase`.

#### `dontUseWafBuild` {#dont-use-waf-build}

When set to true, don't use the predefined `wafBuildPhase`.

#### `dontUseWafInstall` {#dont-use-waf-install}

When set to true, don't use the predefined `wafInstallPhase`.

### Similar variables {#waf-hook-similar-variables}

The following variables are similar to their `stdenv.mkDerivation` counterparts.

| `wafHook` Variable    | `stdenv.mkDerivation` Counterpart |
|-----------------------|-----------------------------------|
| `wafConfigureFlags`   | `configureFlags`                  |
| `wafConfigureTargets` | `configureTargets`                |
| `wafBuildFlags`       | `buildFlags`                      |
| `wafBuildTargets`     | `buildTargets`                    |
| `wafInstallFlags`     | `installFlags`                    |
| `wafInstallTargets`   | `installTargets`                  |

### Honored variables {#waf-hook-honored-variables}

The following variables commonly used by `stdenv.mkDerivation` are honored by `wafHook`.

- `prefixKey`
- `enableParallelBuilding`
- `enableParallelInstalling`
