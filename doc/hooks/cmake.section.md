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

#### `cmakeEntries` {#cmake-entries}

Bash associative array of CMake variable cache entries.
Flags like `-D<key>=<value>` will be prepended to the CMake command-line arguments.
One can specify its initial values via the `stdenv.mkDerivation` argument of the same name, given that `__structuredAttrs` is set to `true`.

We choose `ON` and `OFF` as the canonical CMake boolean values for consistency in this setup hook.
Nevertheless, we don't strictly enforce this policy, but accommodate other CMake-supported boolean values with a set of helper Bash functions, such as [`canonicalizeCMakeBool`](#cmake-bash-helper-canonicalizeCMakeBool), [`cmakeBoolToBash`](#cmake-bash-helper-cmakeBoolToBash), and [`testCMakeBool`](#cmake-bash-helper-testCMakeBool).

Boolean values from the `stdenv.mkDerivation` argument are automatically canonicalized when the command `jq` is available.

#### `cmakeFlags` {#cmake-flags}

Extra flags to pass to `cmake setup` during configure phase.

#### `cmakeBuildDir` {#cmake-build-dir}

Directory where CMake will put intermediate files.

Setting this can be useful for debugging multiple CMake builds while in the same source directory, for example, when building for different platforms.
Different values for each build will prevent build artifacts from interfering with each other.
This setting has no tangible effect when running the build in a sandboxed derivation.

The default value is `build`.

#### `cmakeBuildType` {#cmake-build-type}

Build type of cmake output.

Internally populates the `CMAKE_BUILD_TYPE` cmake flag.

The default value is `Release`.

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

## Bash helper functions provided by CMake {#cmake-bash-helpers}

### `concatCMakeEntryFlagsTo` {#cmake-bash-helper-concatCMakeEntryFlagsTo}

`concatCMakeEntryFlagsTo` takes the variable names of the flags array and CMake entries associative array, and append the flags array with `-D<key>=<value>` flags constructed with the provided CMake entries.

### `canonicalizeCMakeBool` {#cmake-bash-helper-canonicalizeCMakeBool}

`canonicalizeCMakeBool` takes any supported CMake boolean value and prints either `ON` or `OFF`.
If the input value is not supported, it returns 1 after showing an error message.

### `cmakeBoolToBash` {#cmake-bash-helper-cmakeBoolToBash}

`cmakeBoolToBash` takes any supported CMake boolean value and prints either `1` or an empty string, the latter two are the typical values assigned when a derivation attribute with boolean value is passed into a Bash builder.

### `testCMakeBool` {#cmake-bash-helper-testCMakeBool}

`testCMakeBool` takes any supported CMake boolean value and acts as Bash's `true` or `false` command, handy to construct Bash conditional expressions.
If the input value is not supported, it exits the current process with exit status 1.
