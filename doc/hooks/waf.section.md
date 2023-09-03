# wafHook {#wafHook}

[Waf](https://waf.io) is a Python-based software building system.

In Nixpkgs, `wafHook` overrides the default configure, build, and install phases.

## Variables controlling wafHook {#variablesControllingWafHook}

### `wafHook` Exclusive Variables {#wafHookExclusiveVariables}

The variables below are exclusive of `wafHook`.

#### `wafPath` {#wafPath}

Location of the `waf` tool. It defaults to `./waf`, to honor software projects that include it directly inside their source trees.

If `wafPath` doesn't exist, then `wafHook` will copy the `waf` provided from Nixpkgs to it.

#### `wafFlags` {#wafFlags}

Controls the flags passed to waf tool during build and install phases. For settings specific to build or install phases, use `wafBuildFlags` or `wafInstallFlags` respectively.

#### `dontAddWafCrossFlags` {#dontAddWafCrossFlags}

When set to `true`, don't add cross compilation flags during configure phase.

#### `dontUseWafConfigure` {#dontUseWafConfigure}

When set to true, don't use the predefined `wafConfigurePhase`.

#### `dontUseWafBuild` {#dontUseWafBuild}

When set to true, don't use the predefined `wafBuildPhase`.

#### `dontUseWafInstall` {#dontUseWafInstall}

When set to true, don't use the predefined `wafInstallPhase`.

### Similar variables {#similarVariables}

The following variables are similar to their `stdenv.mkDerivation` counterparts.

| `wafHook` Variable    | `stdenv.mkDerivation` Counterpart |
|-----------------------|-----------------------------------|
| `wafConfigureFlags`   | `configureFlags`                  |
| `wafConfigureTargets` | `configureTargets`                |
| `wafBuildFlags`       | `buildFlags`                      |
| `wafBuildTargets`     | `buildTargets`                    |
| `wafInstallFlags`     | `installFlags`                    |
| `wafInstallTargets`   | `installTargets`                  |

### Honored variables {#honoredVariables}

The following variables commonly used by `stdenv.mkDerivation` are honored by `wafHook`.

- `prefixKey`
- `enableParallelBuilding`
- `enableParallelInstalling`
