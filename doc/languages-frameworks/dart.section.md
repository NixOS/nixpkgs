# Dart {#sec-language-dart}

## Dart applications {#ssec-dart-applications}

The function `buildDartApplication` builds Dart applications managed with pub.

It fetches its Dart dependencies automatically through `pub2nix`, and (through a series of hooks) builds and installs the executables specified in the pubspec file. The hooks can be used in other derivations, if needed. The phases can also be overridden to do something different from installing binaries.

If you are packaging a Flutter desktop application, use [`buildFlutterApplication`](#ssec-dart-flutter) instead.

`pubspecLock` is the parsed pubspec.lock file. pub2nix uses this to download required packages.
This can be converted to JSON from YAML with something like `yq . pubspec.lock`, and then read by Nix.

Alternatively, `autoPubspecLock` can be used instead, and set to a path to a regular `pubspec.lock` file. This relies on import-from-derivation, and is not permitted in Nixpkgs, but can be useful at other times.

::: {.warning}
When using `autoPubspecLock` with a local source directory, make sure to use a
concatenation operator (e.g. `autoPubspecLock = src + "/pubspec.lock";`), and
not string interpolation.

String interpolation will copy your entire source directory to the Nix store and
use its store path, meaning that unrelated changes to your source tree will
cause the generated `pubspec.lock` derivation to rebuild!
:::

If the package has Git package dependencies, the hashes must be provided in the `gitHashes` set. If a hash is missing, an error message prompting you to add it will be shown.

The `dart` commands run can be overridden through `pubGetScript` and `dartCompileCommand`; you can also add flags using `dartCompileFlags` or `dartJitFlags`.

Dart supports multiple [outputs types](https://dart.dev/tools/dart-compile#types-of-output); you can choose between them using `dartOutputType` (defaults to `exe`). If you want to override the binaries path or the source path they come from, you can use `dartEntryPoints`. Outputs that require a runtime will automatically be wrapped with the relevant runtime (`dartaotruntime` for `aot-snapshot`, `dart run` for `jit-snapshot` and `kernel`, `node` for `js`); this can be overridden through `dartRuntimeCommand`.

```nix
{
  lib,
  buildDartApplication,
  fetchFromGitHub,
}:

buildDartApplication (finalAttrs: {
  pname = "dart-sass";
  version = "1.62.1";

  src = fetchFromGitHub {
    owner = "sass";
    repo = "dart-sass";
    tag = finalAttrs.version;
    hash = "sha256-U6enz8yJcc4Wf8m54eYIAnVg/jsGi247Wy8lp1r1wg4=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;
})
```

### Patching dependencies {#ssec-dart-applications-patching-dependencies}

Some Dart packages require patches or build environment changes. Package derivations can be customised with the `customSourceBuilders` argument.

A collection of such customisations can be found in Nixpkgs, in the `development/compilers/dart/package-source-builders` directory.

This allows fixes for packages to be shared between all applications that use them. It is strongly recommended to add to this collection instead of including fixes in your application derivation itself.

### Running executables from dev_dependencies {#ssec-dart-applications-build-tools}

Many Dart applications require executables from the `dev_dependencies` section in `pubspec.yaml` to be run before building them.

This can be done in `preBuild`, in one of two ways:

1. Packaging the tool with `buildDartApplication`, adding it to Nixpkgs, and running it like any other application
2. Running the tool from the package cache

Of these methods, the first is recommended when using a tool that does not need
to be of a specific version.

For the second method, the `packageRun` function from the `dartConfigHook` can be used.
This is an alternative to `dart run` that does not rely on Pub.

e.g., for `build_runner`:

```bash
packageRun build_runner build
```

Do _not_ use `dart run <package_name>`, as this will attempt to download dependencies with Pub.

### Usage with nix-shell {#ssec-dart-applications-nix-shell}

#### Using dependencies from the Nix store {#ssec-dart-applications-nix-shell-deps}

As `buildDartApplication` provides dependencies instead of `pub get`, Dart needs to be explicitly told where to find them.

Run the following commands in the source directory to configure Dart appropriately.
Do not use `pub` after doing so; it will download the dependencies itself and overwrite these changes.

```bash
cp --no-preserve=all "$pubspecLockFilePath" pubspec.lock
mkdir -p .dart_tool && cp --no-preserve=all "$packageConfig" .dart_tool/package_config.json
```

## Flutter applications {#ssec-dart-flutter}

The function `buildFlutterApplication` builds Flutter applications.

`targetFlutterPlatform` defaults to `"linux"` on Linux and `"macos"` on Darwin.
It can also be set to `"web"` on either platform.

See the [Dart documentation](#ssec-dart-applications) for more details on required files and arguments.

`flutter` in Nixpkgs always points to `flutterPackages.stable`, which is the latest packaged version. To avoid unforeseen breakage during upgrade, packages in Nixpkgs should use a specific flutter version, such as `flutter335` and `flutter338`, instead of using `flutter` directly.

```nix
{ flutter335, fetchFromGitHub }:

flutter335.buildFlutterApplication (finalAttrs: {
  pname = "firmware-updater";
  version = "0-unstable-2025-09-09";

  # To build for the Web, use the targetFlutterPlatform argument.
  # targetFlutterPlatform = "web";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "firmware-updater";
    rev = "402e97254b9d63c8d962c46724995e377ff922c8";
    hash = "sha256-nQn5mlgNj157h++67+mhez/F1ALz4yY+bxiGsi0/xX8=";
    fetchSubmodules = true;
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  sourceRoot = "${finalAttrs.src.name}/apps/firmware_updater";

  gitHashes.fwupd = "sha256-l/+HrrJk1mE2Mrau+NmoQ7bu9qhHU6wX68+m++9Hjd4=";
})
```

### macOS applications {#ssec-dart-flutter-macos}

Build a macOS application from a source directory containing `pubspec.lock.json`:

```nix
{ flutter347, lib }:

flutter347.buildFlutterApplication {
  pname = "example";
  version = "1.0.0";
  src = ./.;
  pubspecLock = lib.importJSON ./pubspec.lock.json;
}
```

On Darwin, the builder selects `targetFlutterPlatform = "macos"`.
The builder installs the application in `$out/Applications` and creates `$out/bin/example`.

macOS builds require the full Apple Xcode toolchain.
The builder uses `darwin.xcode_27` by default.
Download Xcode from Apple and import it into the Nix store using the instructions printed by the Xcode package.
Xcode is unfree; enable unfree packages in your Nixpkgs configuration.
Override the builder's `xcode` argument to select another Xcode version.
Nixpkgs' `xcbuild` does not implement the commands Flutter uses, including Swift package resolution.

For sandboxed builds, set `sandbox = relaxed` in the Nix configuration.
Xcode needs access to the LaunchServices file-type database (`com.apple.lsd.mapdb`).
The builder adds a sandbox rule for that lookup.
Nix rejects custom sandbox rules with `sandbox = true`.
The builder does not set `__noChroot`.

The builder signs applications ad hoc and overrides upstream team and provisioning-profile settings.
Applications that require provisioned Apple capabilities, such as iCloud, need a separate signing setup.
Hardened applications retain hardened runtime and receive the `com.apple.security.cs.disable-library-validation` entitlement so their ad hoc signed frameworks load without an Apple Team ID.
The builder applies the same entitlement to hardened helper applications and app extensions.

Supply pub dependencies through `pubspecLock`.
Flutter selects CocoaPods, Swift Package Manager, or both from the SDK and project settings.
The builder preserves existing Podfiles, local pod declarations, and install hooks.
Shared Dart package source builders connect supported plugins to Nixpkgs libraries, including MDK, mpv, and SQLite.
Supply additional native dependencies through Nix to keep builds offline.

Use `swiftPackages` to map repository URLs in the application's Xcode project to Nix-fetched source directories.
The builder replaces those remote references with local references and preserves the selected products.
Provide dependencies of those Swift packages locally too.

Native `preBuild` hooks use the Nix compiler and SDK.
The builder selects the full Xcode toolchain when the Flutter build starts.
Builds target the Nix host architecture.
The builder raises deployment targets to the minimum required by Xcode or Nix stdenv and preserves higher project targets and application sandbox entitlements.

Use `flutterMode` to select the build mode, as on Linux.
The default mode is `release`.
The builder writes Dart debug information to the `debug` output.
Set project-specific flavors, such as `production`, through `flutterBuildFlags`.

### Usage with nix-shell {#ssec-dart-flutter-nix-shell}

Flutter-specific `nix-shell` usage notes are included here. See the [Dart documentation](#ssec-dart-applications-nix-shell) for general `nix-shell` instructions.

#### Entering the shell {#ssec-dart-flutter-nix-shell-enter}

By default, dependencies for only the `targetFlutterPlatform` are available in the
build environment. This is useful for keeping closures small but can be problematic
during development. It's common, for example, to build Web apps for Linux during
development to take advantage of native features such as stateful hot reload.

To enter a shell with all the usual target platforms available, use the `multiShell` attribute.

e.g. `nix-shell '<nixpkgs>' -A fluffychat-web.multiShell`.
