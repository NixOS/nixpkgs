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

`cmakeEntries`

: Attribute set and Bash associative array of CMake variable cache entries.
Flags like `-D<key>=<value>` will be prepended to the CMake command-line arguments.
One can specify its initial values via the `stdenv.mkDerivation` argument of the same name, given that `__structuredAttrs` is set to `true`.

  We observe the canonical CMake boolean values (`ON` and `OFF`) and other canonicalisation during CMake's JSON reading.
`sourceCMakeEntriesVar` canonicalise the `cmakeEntries` shell variable from the `stdenv.mkDerivation`'s `cmakeEntries` argument during `${prePhases[@]}` when `__structuredAttrs` is `true`.

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

`$NIX_ATTRS_JSON_FILE` is the main source of truth for `cmakeEntries` and `cmakeFlags` when `__structuredAttrs = true`,
allowing build tools to get the same CMake flags information as `cmakeConfigurePhase` does.
`cmake`'s hooks provide specilised getters and setters that works with both the JSON file and the shell variables.

Some other Bash helper functions facilitate string conversion and canonicalisation.

### `cmakeEntries` getters {#cmake-bash-helpers-cmakeEntries-getters}

`concatCMakeEntryFlagsTo FLAGS_ARRAY_VARNAME [CMAKE_ENTRIES_VARNAME]`

: Take the variable names of the flags array and CMake entries associative array, and append the flags array with `-D<key>=<value>` flags constructed with the provided CMake entries.

`getCMakeEntry KEY [DEFAULT]`

: Get the canonicalised `cmakeEntries` value for key `KEY`.

  When not found, fall back to the optional `DEFAULT` or throw error.

  Throw error if unexpected JSON type encountered.

`getCMakeEntryJSON KEY [DEFAULT]`

: `getCMakeEntry` but return raw JSON.

  Require `__structuredAttrs = true`.

`sourceCMakeEntriesVar`

: Read `cmakeEntries` values from the JSON file and reset the Bash associative array accordingly.

### `cmakeEntries` setters {#cmake-bash-helpers-cmakeEntries-setters}

`<prepend,append>CMakeEntry<JSON,Bool,String> KEY VALUE`

: Set the `cmakeEntries` value for a specific `KEY`.

  The `prepend`/`append` prefix controls whether the setter overrides an existing value, while the `JSON`/`Bool`/`String` suffix corresponds to the input `VALUE` type.

  `<prepend,append>CMakeEntryJSON` throw error if unexpected JSON type encountered.

`removeCMakeEntry KEY`

: Remove `KEY` from `cmakeEntries`.

### `cmakeFlags` getters {#cmake-bash-helpers-cmakeFlags-getters}

`sourceCMakeFlagsVar`

: Read `cmakeFlags` values from the JSON file and reset the Bash array accordingly.

### `cmakeFlags` setters {#cmake-bash-helpers-cmakeFlags-setters}

`<prepend/append>CmakeFlags [FLAG1 ...]`

: Prepend/append to `cmakeFlags`.

`removeCMakeFlag PATTERN`

: Remove all flags equal to `PATTERN` from `cmakeFlags`.

  Require `__structuredAttrs = true`.

`removeMatchedCMakeFlag PATTERN`

: Remove each flag, (part of) which is matched by the regular expression `PATTERN`, from `cmakeFlags`.

  Require `__structuredAttrs = true`.

`setCMakeFlagsFromVar`

: Set `cmakeFlags` from the shell variable.

### String conversion helpers {#cmake-bash-helpers-conversion}

`cmakeValueFromJSON INPUT_JSON`

: Take a JSON expression `INPUT_JSON` and convert it to a value for `-DKEY=VALUE`.

  Throw error if unexpected JSON type encountered.

`canonicaliseCMakeBool BOOL_STRING`

: Take any supported CMake boolean value and prints either `ON` or `OFF`.

  Throw error if the input value is not supported.

`cmakeBoolToJSON BOOL_STRING`

: Take a CMake boolean value and return a json boolean.

`cmakeStringToJSON INPUT_STRING`

: Escape/encode a string to JSON.

`cmakeGetJSONType INPUT_JSON`

: Take a JSON expression and print its type.
