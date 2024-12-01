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

#### `cmakeFlags` {#cmake-flags}

Controls the flags passed to `cmake setup` during configure phase.

#### `cmakeBuildDir` {#cmake-build-dir}

Directory where CMake will put intermediate files.

Setting this can be useful for debugging multiple CMake builds while in the same source directory, for example, when building for different platforms.
Different values for each build will prevent build artefacts from interefering with each other.
This setting has no tangible effect when running the build in a sandboxed derivation.

The default value is `build`.

#### `dontUseCmakeConfigure` {#dont-use-cmake-configure}

When set to true, don't use the predefined `cmakeConfigurePhase`.
