# `just` {#just-hook}

This setup hook attempts to use [the `just` command runner](https://just.systems/man/en/) to build, check, and install the package. The hook overrides `buildPhase`, `checkPhase`, and `installPhase` by default.

[]{#just-hook-justFlags} The `justFlags` variable can be set to a list of strings to add additional flags passed to all invocations of `just`.

## `buildPhase` {#just-hook-buildPhase}

This phase attempts to invoke `just` with [the default recipe](https://just.systems/man/en/the-default-recipe.html).

[]{#just-hook-dontUseJustBuild} This behavior can be disabled by setting `dontUseJustBuild` to `true`.

## `checkPhase` {#just-hook-checkPhase}

This phase attempts to invoke the `just test` recipe, if it is available. This can be overridden by setting `checkTarget` to a string.

[]{#just-hook-dontUseJustCheck} This behavior can be disabled by setting `dontUseJustCheck` to `true`.

## `installPhase` {#just-hook-installPhase}

This phase attempts to invoke the `just install` recipe.

[]{#just-hook-dontUseJustInstall} This behavior can be disabled by setting `dontUseJustInstall` to `true`.
