# cmake {#cmake}

Overrides the default configure phase to run the CMake command.

By default, we use the Make generator of CMake.
But when Ninja is also available as a `nativeBuildInput`, this setup hook will detect that and use the ninja generator.

Dependencies are added automatically to `CMAKE_PREFIX_PATH` so that packages are correctly detected by CMake.
Some additional flags are passed in to give similar behavior to configure-based packages.

By default, parallel building is enabled as CMake supports parallel building almost everywhere.

You can disable this hook’s behavior by setting `configurePhase` to a custom value, or by setting `dontUseCmakeConfigure`.

## Variables controlling CMake {#cmake-variables-controlling}

### CMake Exclusive Variables {#cmake-exclusive-variables}

#### `cmakeEntries` and `cmakeEntryTypes` {#cmake-entries}

Bash associative arrays of CMake variable cache entries and their types.
Flags like `-D<key>:<type>=<value>` will be prepended to the CMake command-line arguments.

Empty type will be treated the same way as `"UNINITIALIZED"`,
which won't present in the flag string (i.e., `-D<key>=<value>`).

Given that `cmakeEntries[WITH_FOO]` is defined and `[[ cmakeEntryTypes[WITH_FOO] == BOOL ]]`,
one can determine the condition with `[[ -n "${cmakeEntries[WITH_FOO]}" ]]`.
When prepending to the flags, however, the value will become converted to either `ON` or `OFF`.

One can specify their initial values via the Nix derivation attribute of the same name,
given that `__structuredAttrs` is set to `true`.

When command `jq` is available,
`cmakeEntries` values specified as Nix Language boolean go through additional canonicalization:
1. If the types are not specified in `cmakeEntryTypes`,
   the types are specified as `BOOL`.
2. If the types are specified in `cmakeEntryTypes` but is not `BOOL`,
   the `cmakeEntries` values will be cast in-place into `ON` or `OFF`.

To enable the above-mentioned canonicalization whenever available,
non-minimal-build `cmake` packages propagate the `jq` native build inputs.
To opt out such propagation, override as `cmake.override { jq = null; }` or use `cmakeMinimal`.

#### `cmakeFlags` {#cmake-flags}

Extra flags to pass to `cmake setup` during configure phase.

#### `cmakeBuildDir` {#cmake-build-dir}

Directory where CMake will put intermediate files.

Setting this can be useful for debugging multiple CMake builds while in the same source directory, for example, when building for different platforms.
Different values for each build will prevent build artifacts from interfering with each other.
This setting has no tangible effect when running the build in a sandboxed derivation.

The default value is `build`.

#### `dontUseCmakeConfigure` {#dont-use-cmake-configure}

When set to true, don't use the predefined `cmakeConfigurePhase`.

## Controlling CTest invocation {#cmake-ctest}

By default tests are run by make in [`checkPhase`](#ssec-check-phase) or by [ninja](#ninja) if `ninja` is
available in `nativeBuildInputs`. Makefile and Ninja generators produce the `test` target, which invokes `ctest` under the hood.
This makes passing additional arguments to `ctest` difficult, so it's possible to invoke it directly in `checkPhase`
by adding `ctestCheckHook` to `nativeCheckInputs`.

### CTest Variables {#cmake-ctest-variables}

#### `disabledTests` {#cmake-ctest-disabled-tests}

Allows to disable running a list of tests. Note that regular expressions are not supported by `disabledTests`, but
it can be combined with `--exclude-regex` option.

#### `ctestFlags` {#cmake-ctest-flags}

Additional options passed to `ctest` together with `checkFlags`.
