# Swift {#swift}

The Swift compiler is provided by the `swift` package:

```sh
# Compile and link a simple executable.
nix-shell -p swift --run 'swiftc -' <<< 'print("Hello world!")'
# Run it!
./main
```

The `swift` package also provides the `swift` command, with some caveats:

- Swift Package Manager (SwiftPM) is packaged separately as `swiftpm`. If you
  need functionality like `swift build`, `swift run`, `swift test`, you must
  also add the `swiftpm` package to your closure.
- On Darwin, the `swift repl` command requires an Xcode installation. This is
  because it uses the system LLDB debugserver, which has special entitlements.

## Module search paths {#ssec-swift-module-search-paths}

Like other toolchains in Nixpkgs, the Swift compiler executables are wrapped
to help Swift find your application's dependencies in the Nix store. These
wrappers scan the `buildInputs` of your package derivation for specific
directories where Swift modules are placed by convention, and automatically
add those directories to the Swift compiler search paths.

Swift follows different conventions depending on the platform. The wrappers
look for the following directories:

- On Darwin platforms: `lib/swift/macosx`
  (If not targeting macOS, replace `macosx` with the Xcode platform name.)
- On other platforms: `lib/swift/linux/x86_64`
  (Where `linux` and `x86_64` are from lowercase `uname -sm`.)
- For convenience, Nixpkgs also adds `lib/swift` to the search path.
  This can save a bit of work packaging Swift modules, because many Nix builds
  will produce output for just one target any way.

## Core libraries {#ssec-swift-core-libraries}

In addition to the standard library, the Swift toolchain contains some
additional 'core libraries' that, on Apple platforms, are normally distributed
as part of the OS or Xcode. These are packaged separately in Nixpkgs, and can
be found (for use in `buildInputs`) as:

- `swiftPackages.Dispatch`
- `swiftPackages.Foundation`
- `swiftPackages.XCTest`

## Packaging with SwiftPM {#ssec-swift-packaging-with-swiftpm}

Nixpkgs includes a small helper `swiftpm2nix` that can fetch your SwiftPM
dependencies for you, when you need to write a Nix expression to package your
application.

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

This produces some files in a directory `nix`, which will be part of your Nix
expression. The next step is to write that expression:

```nix
{ stdenv, swift, swiftpm, swiftpm2nix, fetchFromGitHub }:

let
  # Pass the generated files to the helper.
  generated = swiftpm2nix.helpers ./nix;
in

stdenv.mkDerivation rec {
  pname = "myproject";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "nixos";
    repo = pname;
    rev = version;
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  # Including SwiftPM as a nativeBuildInput provides a buildPhase for you.
  # This by default performs a release build using SwiftPM, essentially:
  #   swift build -c release
  nativeBuildInputs = [ swift swiftpm ];

  # The helper provides a configure snippet that will prepare all dependencies
  # in the correct place, where SwiftPM expects them.
  configurePhase = generated.configure;

  installPhase = ''
    # This is a special function that invokes swiftpm to find the location
    # of the binaries it produced.
    binPath="$(swiftpmBinPath)"
    # Now perform any installation steps.
    mkdir -p $out/bin
    cp $binPath/myproject $out/bin/
  '';
}
```

### Custom build flags {#ssec-swiftpm-custom-build-flags}

If you'd like to build a different configuration than `release`:

```nix
swiftpmBuildConfig = "debug";
```

It is also possible to provide additional flags to `swift build`:

```nix
swiftpmFlags = [ "--disable-dead-strip" ];
```

The default `buildPhase` already passes `-j` for parallel building.

If these two customization options are insufficient, provide your own
`buildPhase` that invokes `swift build`.

### Running tests {#ssec-swiftpm-running-tests}

Including `swiftpm` in your `nativeBuildInputs` also provides a default
`checkPhase`, but it must be enabled with:

```nix
doCheck = true;
```

This essentially runs: `swift test -c release`

### Patching dependencies {#ssec-swiftpm-patching-dependencies}

In some cases, it may be necessary to patch a SwiftPM dependency. SwiftPM
dependencies are located in `.build/checkouts`, but the `swiftpm2nix` helper
provides these as symlinks to read-only `/nix/store` paths. In order to patch
them, we need to make them writable.

A special function `swiftpmMakeMutable` is available to replace the symlink
with a writable copy:

```
configurePhase = generated.configure ++ ''
  # Replace the dependency symlink with a writable copy.
  swiftpmMakeMutable swift-crypto
  # Now apply a patch.
  patch -p1 -d .build/checkouts/swift-crypto -i ${./some-fix.patch}
'';
```

## Considerations for custom build tools {#ssec-swift-considerations-for-custom-build-tools}

### Linking the standard library {#ssec-swift-linking-the-standard-library}

The `swift` package has a separate `lib` output containing just the Swift
standard library, to prevent Swift applications needing a dependency on the
full Swift compiler at run-time. Linking with the Nixpkgs Swift toolchain
already ensures binaries correctly reference the `lib` output.

Sometimes, Swift is used only to compile part of a mixed codebase, and the
link step is manual. Custom build tools often locate the standard library
relative to the `swift` compiler executable, and while the result will work,
when this path ends up in the binary, it will have the Swift compiler as an
unintended dependency.

In this case, you should investigate how your build process discovers the
standard library, and override the path. The correct path will be something
like: `"${swift.swift.lib}/${swift.swiftModuleSubdir}"`
