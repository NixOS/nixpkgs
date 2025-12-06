# Ant {#ant}

[Ant](https://ant.apache.org) is a build system.
It is primarily used to build Java projects.

## `ant.hook` {#ant-hook}

The `ant.hook` setup hook sets `buildPhase` and `checkPhase` by default.

### `ant` thin wrapper {#ant-hook-thin-wrapper}

The `ant` command is thinly wrapped by a Bash function of the same name.
The function executes `ant` with the contents of the `antFlags` variable
(and the associated `antFlagsArray`).

This wrapper is always used in place of `ant` inside of the derivation.
It can be circumvented by calling `command ant`.

### `findExternalAntTasks` {#ant-hook-findExternalAntTasks}

This hook traverses all dependencies of the derivation. If it finds a
`/share/ant/lib` directory, that directory is appended to `antFlagsArray`
with the `-lib` argument.

### `buildPhase` {#ant-hook-buildPhase}

The Ant `buildPhase` executes `ant` with no arguments by default.

#### Parameters {#ant-hook-buildPhase-parameters}

`dontUseAntBuild`
: When set to `true`, disables setting this phase as `buildPhase`.
`antBuildFlags`
: Additional flags passed to Ant in this phase.
`antBuildFlagsArray`
: Additional flags passed to Ant in this phase, as a Bash array.

### `checkPhase` {#ant-hook-checkPhase}

The Ant `checkPhase` executes `ant check` by default.
This default can be changed by setting `antCheckFlags` or `antCheckFlagsArray`.

#### Parameters {#ant-hook-checkPhase-parameters}

`dontUseAntCheck`
: When set to `true`, disables setting this phase as `checkPhase`.
`antCheckFlags`
: Additional flags passed to Ant in this phase.
`antCheckFlagsArray`
: Additional flags passed to Ant in this phase, as a Bash array.

