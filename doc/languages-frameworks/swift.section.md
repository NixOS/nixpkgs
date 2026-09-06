# Swift {#swift}

The Swift compiler is provided by the `swift` package:

```sh
# Compile and link a simple executable.
nix-shell -p swift --run 'swiftc -' <<< 'print("Hello world!")'
# Run it!
./main
```

The `swift` package also provides the `swift` command, with some caveats:

- Swift Package Manager (SwiftPM) is packaged separately as `swiftpm`.
  If you need functionality like `swift build`, `swift run`, `swift test`, you must also add the `swiftpm` package to your closure.
- On Darwin, the `swift repl` command requires an Xcode installation.
  This is because it uses the system LLDB debugserver, which has special entitlements.

## Module search paths {#ssec-swift-module-search-paths}

The Swift compiler executables are patched to find the C and C++ standard libraries associated with its target platform, but they are not wrapped.
They will not find your application’s dependencies automatically in the Nix store.
Your build system is expected to handle this for you.

SwiftPM provides a hook that scans the `buildInputs` of your package derivation for specific directories where the Swift modules are placed by convention.
These directories are added automatically to `swiftpmFlags` when the hook runs.
Swift in Nixpkgs follows a few conventions when installing dependencies:

- Libraries (both shared and static) are installed to `lib`.
  This differs from upstream packaging, but it matches how other langauges are packaged in Nixpkgs.
  This allows Swift packages to take advantage of existing tooling that expects libraries to be installed in this standard location.
- Modules are installed to `lib/swift/<platform>` where `<platform>` is the Swift platform for your host platform (e.g., `lib/swift/macosx` or `lib/swift/linux`).
  Note that Linux modules may be installed in a directory specific to the target architecture(e.g., `lib/swift/linux/x86_64`), but this is uncommon.
  Upstream Swift appears to be moving away from this convention.

## Core libraries {#ssec-swift-core-libraries}

The `swift` package contains a complete toolchain with the Swift stdlib, Dispatch, Foundation, XCTest, and Swift Testing.
These packages do not need to  be added to `buildInputs` when packaging applications.
The Swift compiler will  find them automatically in the `swift` toolchain.

If you do need to use these packages outside of the Swift toolchain, they are  available in the following packages:

- `swiftPackages.stdlib` contains the Swift stdlib and backdeployment dylibs.
- `swiftPackages.swift-corelibs-libdispatch` contains the Dispatch framework.
- `swiftPackages.swift-corelibs-foundation` contains the Foundation framework.
- `swiftPackages.swift-corelibs-xctest` and `swiftPackages.swift-testing` contain the XCTest and Swift Testing frameworks respectively.

Note: On Darwin, the Swift stdlib has been removed from the SDK.
The Swift toolchain contains the stubs and modules required to build Swift applications with the following exceptions:

- Swift Differentiation is shipped as a dylib in Nixpkgs because it is no longer shipped with the OS (as of macOS 26.4).
  This allows packages using Swift Differentiation to work regardless of OS version.
- The Span back-deployment dylib is shipped with the stdlib.
- This is expected because back-deployment dylibs are normally shipped with the toolchain.
- FoundationMacros is built and shipped as a dylib in `swiftPackages.swift-foundation` and included the toolchain.
  Macros are actually compiler plugins executed at build time.
  Without this, FoundationMacros would not work on Darwin.

## Packaging with SwiftPM {#ssec-swift-packaging-with-swiftpm}

Nixpkgs includes two ways to package dependencies for Swift applications: `fetchSwiftPMDeps` and `swiftpm2nix`.
While `swiftpm2nix` is not deprecated, using `fetchSwiftPMDeps` is preferred because it is easier to use and does not (usually) require shipping extra files with your package.

### Packaging with `fetchSwiftPMDeps` {#ssec-swift-packaging-with-fetch-swiftpm-deps}

Swift provides a fetcher that will download all of your dependencies based on the `Package.resolved` shipped by your package.
If your package does not ship one, you will have to generate it yourself and provide it with your package.
Otherwise, set `swiftpmDeps` as follows:

```nix
{
  swiftpmDeps = fetchSwiftPMDeps {
    inherit src;
    hash = "sha256-1KfyrQXE1HaO9WsuskzgiiEZxM/oelp40Jwzr8xJEL4=";
  };
}
```

The `src` attribute is required as is the `hash`.
The first time you build your  package, you will need to set `hash` to an empty value by using `lib.fakeHash` to get the hash for your dependencies.
The following optional attributes can also be used:

- `name`: Sets the name of the vendored dependencies fixed-output derivation.
  You can also use `pname` and `version` to set the `name`.
  This is often easier because you can inherit them from `finalAttrs`.
- `sourceRoot`: Sets the path where `Package.swift` and `Package.resolved` can be found if they are not in their default, top-level location.
- `patches`: Can be used to apply patches to your project before the depencies are vendored.
  This is useful to update `Package.swift` or `Package.resolved`.
- `postPatch`: Can be used to perform extra steps after patching.
  You can copy a custom `Package.resolved` in `postPatch`.

### Packaging with `swiftpm2nix` {#ssec-swift-packaging-with-swiftpm2nix}

The first step is to run the generator:

```sh
cd /path/to/my/project
# Enter a Nix shell with the required tools.
nix-shell -p swift swiftpm swiftpm2nix
# First, make sure the workspace is up-to-date.
swift package resolve
# Now generate the Nix code.
swiftpm2nix
```

This produces some files in a directory `nix`, which will be part of your Nix  expression.
The next step is to write that expression:

```nix
{
  stdenv,
  swift,
  swiftpm,
  swiftpm2nix,
  fetchFromGitHub,
}:

let
  # Pass the generated files to the helper.
  generated = swiftpm2nix.helpers ./nix;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "myproject";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "nixos";
    repo = "myproject";
    tag = finalAttrs.version;
    hash = "";
  };

  # Including SwiftPM as a nativeBuildInput provides a buildPhase for you.
  # This by default performs a release build using SwiftPM, essentially:
  #   swift build -c release
  nativeBuildInputs = [
    swift
    swiftpm
  ];

  # The helper provides a configure snippet that will prepare all dependencies
  # in the correct place, where SwiftPM expects them.
  configurePhase = ''
    runHook preConfigure

    ${generated.configure}

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    # This is a special function that invokes swiftpm to find the location
    # of the binaries it produced.
    binPath="$(swiftpmBinPath)"
    # Now perform any installation steps.
    mkdir -p $out/bin
    cp $binPath/myproject $out/bin/

    runHook postInstall
  '';
})
```

#### Patching dependencies {#ssec-swiftpm-patching-dependencies}

In some cases, it may be necessary to patch a SwiftPM dependency.
SwiftPM dependencies are located in `.build/checkouts`, but the `swiftpm2nix` helper provides these as symlinks to read-only `/nix/store` paths.
To patch them, we need to make them writable.

A special function `swiftpmMakeMutable` is available to replace the symlink with a writable copy:

```nix
{
  configurePhase = ''
    runHook preConfigure

    ${generated.configure}

    # Replace the dependency symlink with a writable copy.
    swiftpmMakeMutable swift-crypto
    # Now apply a patch.
    patch -p1 -d .build/checkouts/swift-crypto -i ${./some-fix.patch}

    runHook postConfigure
  '';
}
```

### Custom build flags {#ssec-swiftpm-custom-build-flags}

If you'd like to build a different configuration than `release`:

```nix
{ swiftpmBuildConfig = "debug"; }
```

It is also possible to provide additional flags to `swift build`:

```nix
{ swiftpmFlags = [ "--disable-dead-strip" ]; }
```

The default `buildPhase` already passes `-j` for parallel building.

If these two customization options are insufficient, provide your own `buildPhase` that invokes `swift build`.

### Running tests {#ssec-swiftpm-running-tests}

Including `swiftpm` in your `nativeBuildInputs` also provides a default `checkPhase`, but it must be enabled with:

```nix
{ doCheck = true; }
```

This essentially runs: `swift test -c release`

### Installing packages {#ssec-swiftpm-install-phase}

SwiftPM provides a default install phase that installs any products specified in your package’s `Package.swift`.
If your package does not specify any products, which is not uncommon, you will have to manually install them to `out`.
To disable the SwiftPM install phase, include the following in your derivation:

```nix
{ dontUseSwiftpmInstall = true; }
```

## Hooks {#ssec-swift-hooks}

Swift provides the following hooks to automate builds and unpack dependencies:

- `swiftpmHook`: Propagated by `swiftpm`.
  Also propagates `swiftpmUnpackHook`.
  Provides build, install, and check phases. It also adds any dependencies found in `buildInputs` to `swiftpmFlags`.
- `swiftpmUnpackHook`: Sets up `workspace-state.json` and links vendored dependencies to the top-level `Packages` directory in the build environment.

Swift also provides a hook with the toolchain to replace rpath references to  the toolchain with references to the stdlib package.
This hook is used automatically by the `swift` package.
This avoids pulling the entire toolchain into the closure of your package.

## Considerations for custom build tools {#ssec-swift-considerations-for-custom-build-tools}

### Linking the standard library {#ssec-swift-linking-the-standard-library}

The Swift stdlib is packaged separately as `swiftPackages.stdlib`.
The shared and static libraries are installed to `lib`.
Most tooling in Nixpkgs should find them automatically when linking.
The stdlib provides a hook to change any rpaths pointing to the toolchain to point to the stdlib instead.

The stdlib modules are installed to `lib/swift/<platform>` in the `dev` output of the stdlib package.
These are symlinked together into the `swift` toolchain.
If your build tools locate the modules relative to the `swift` compiler  executable, it should do the right thing automatically.

### Accessing properties of the Swift platform {#ssec-swift-platform-properties}

The architecture, platform, and triple used by Swift is available as attributes on the build/host/targetPlatform for the `stdenv`.

- `stdenv.<platform>.swift.platform`: The Swift platform (e.g., `macosx` for macOS, `linux` for Linux, etc).
- `stdenv.<platform>.swift.arch`: The Swift architecture (e.g., `arm64` for Darwin or `aarch64` for Linux, `x86_64`, etc).
- `stdenv.<platform>.swift.triple`: The triple used by Swift.
  This is the same as `stdenv.<platform>.config` except on Darwin.
  On Darwin, it uses the OS name instead of `darwin` and includes the deployment target (e.g., `arm64-apple-macosx14.0`).
