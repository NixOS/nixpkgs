# Premake {#premake-hook}

This setup hook attempts to configure the package using [the Premake build configuration system](https://premake.github.io/). It overrides the `configurePhase` by default, if none exists.

[]{#premake-hook-premakefile} The Premakefile to use can be specified by setting `premakefile` in the derivation.

[]{#premake-hook-premakeFlagsArray} The flags passed to Premake can be configured by adding strings to the `premakeFlags` list.
