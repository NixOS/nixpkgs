
### cmake {#cmake}

Overrides the default configure phase to run the CMake command. By default, we use the Make generator of CMake. In addition, dependencies are added automatically to `CMAKE_PREFIX_PATH` so that packages are correctly detected by CMake. Some additional flags are passed in to give similar behavior to configure-based packages. You can disable this hook’s behavior by setting `configurePhase` to a custom value, or by setting `dontUseCmakeConfigure`. `cmakeFlags` controls flags passed only to CMake. By default, parallel building is enabled as CMake supports parallel building almost everywhere. When Ninja is also in use, CMake will detect that and use the ninja generator.
