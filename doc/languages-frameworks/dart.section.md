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

The `dart` commands run can be overridden through `pubGetScript` and `dartCompileCommand`, you can also add flags using `dartCompileFlags` or `dartJitFlags`.

Dart supports multiple [outputs types](https://dart.dev/tools/dart-compile#types-of-output), you can choose between them using `dartOutputType` (defaults to `exe`). If you want to override the binaries path or the source path they come from, you can use `dartEntryPoints`. Outputs that require a runtime will automatically be wrapped with the relevant runtime (`dartaotruntime` for `aot-snapshot`, `dart run` for `jit-snapshot` and `kernel`, `node` for `js`), this can be overridden through `dartRuntimeCommand`.

```nix
{ lib, buildDartApplication, fetchFromGitHub }:

buildDartApplication rec {
  pname = "dart-sass";
  version = "1.62.1";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    hash = "sha256-U6enz8yJcc4Wf8m54eYIAnVg/jsGi247Wy8lp1r1wg4=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;
}
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

See the [Dart documentation](#ssec-dart-applications) for more details on required files and arguments.

`flutter` in Nixpkgs always points to `flutterPackages.stable`, which is the latest packaged version. To avoid unforeseen breakage during upgrade, packages in Nixpkgs should use a specific flutter version, such as `flutter319` and `flutter322`, instead of using `flutter` directly.

```nix
{  flutter, fetchFromGitHub }:

flutter322.buildFlutterApplication {
  pname = "firmware-updater";
  version = "0-unstable-2023-04-30";

  # To build for the Web, use the targetFlutterPlatform argument.
  # targetFlutterPlatform = "web";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "firmware-updater";
    rev = "6e7dbdb64e344633ea62874b54ff3990bd3b8440";
    sha256 = "sha256-s5mwtr5MSPqLMN+k851+pFIFFPa0N1hqz97ys050tFA=";
    fetchSubmodules = true;
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;
}
```

### Usage with nix-shell {#ssec-dart-flutter-nix-shell}

Flutter-specific `nix-shell` usage notes are included here. See the [Dart documentation](#ssec-dart-applications-nix-shell) for general `nix-shell` instructions.

#### Entering the shell {#ssec-dart-flutter-nix-shell-enter}

By default, dependencies for only the `targetFlutterPlatform` are available in the
build environment. This is useful for keeping closures small, but be problematic
during development. It's common, for example, to build Web apps for Linux during
development to take advantage of native features such as stateful hot reload.

To enter a shell with all the usual target platforms available, use the `multiShell` attribute.

e.g. `nix-shell '<nixpkgs>' -A fluffychat-web.multiShell`.
