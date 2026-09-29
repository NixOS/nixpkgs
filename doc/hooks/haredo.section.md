# `haredo` {#haredo-hook}

This hook uses [the `haredo` command runner](https://sr.ht/~autumnull/haredo/) to build, check, and install the package. It overrides `buildPhase`, `checkPhase`, and `installPhase` by default.

The hook builds its targets in parallel if [`enableParallelBuilding`](#var-stdenv-enableParallelBuilding) is set to `true`.

## `buildPhase` {#haredo-hook-buildPhase}

This phase attempts to build the default target.

[]{#haredo-hook-haredoBuildTargets} Targets can be explicitly set by adding a string to the `haredoBuildTargets` list.

[]{#haredo-hook-dontUseHaredoBuild} This behavior can be disabled by setting `dontUseHaredoBuild` to `true`.

## `checkPhase` {#haredo-hook-checkPhase}

This phase searches for the `check.do` or `test.do` targets, running them if they exist.

[]{#haredo-hook-haredoCheckTargets} Targets can be explicitly set by adding a string to the `haredoCheckTargets` list.

[]{#haredo-hook-dontUseHaredoCheck} This behavior can be disabled by setting `dontUseHaredoCheck` to `true`.

## `installPhase` {#haredo-hook-installPhase}

This phase attempts to build the `install.do` target, if it exists.

[]{#haredo-hook-haredoInstallTargets} Targets can be explicitly set by adding a string to the `haredoInstallTargets` list.

[]{#haredo-hook-dontUseHaredoInstall} This behavior can be disabled by setting `dontUseHaredoInstall` to `true`.
