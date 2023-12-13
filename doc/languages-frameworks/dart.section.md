# Dart {#sec-language-dart}

## Dart applications {#ssec-dart-applications}

The function `buildDartApplication` builds Dart applications managed with pub.

It fetches its Dart dependencies automatically through `fetchDartDeps`, and (through a series of hooks) builds and installs the executables specified in the pubspec file. The hooks can be used in other derivations, if needed. The phases can also be overridden to do something different from installing binaries.

If you are packaging a Flutter desktop application, use [`buildFlutterApplication`](#ssec-dart-flutter) instead.

`vendorHash`: is the hash of the output of the dependency fetcher derivation. To obtain it, set it to `lib.fakeHash` (or omit it) and run the build ([more details here](#sec-source-hashes)).

If the upstream source is missing a `pubspec.lock` file, you'll have to vendor one and specify it using `pubspecLockFile`. If it is needed, one will be generated for you and printed when attempting to build the derivation.

The `depsListFile` must always be provided when packaging in Nixpkgs. It will be generated and printed if the derivation is attempted to be built without one. Alternatively, `autoDepsList` may be set to `true` only when outside of Nixpkgs, as it relies on import-from-derivation.

The `dart` commands run can be overridden through `pubGetScript` and `dartCompileCommand`, you can also add flags using `dartCompileFlags` or `dartJitFlags`.

Dart supports multiple [outputs types](https://dart.dev/tools/dart-compile#types-of-output), you can choose between them using `dartOutputType` (defaults to `exe`). If you want to override the binaries path or the source path they come from, you can use `dartEntryPoints`. Outputs that require a runtime will automatically be wrapped with the relevant runtime (`dartaotruntime` for `aot-snapshot`, `dart run` for `jit-snapshot` and `kernel`, `node` for `js`), this can be overridden through `dartRuntimeCommand`.

```nix
{ buildDartApplication, fetchFromGitHub }:

buildDartApplication rec {
  pname = "dart-sass";
  version = "1.62.1";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    hash = "sha256-U6enz8yJcc4Wf8m54eYIAnVg/jsGi247Wy8lp1r1wg4=";
  };

  pubspecLockFile = ./pubspec.lock;
  depsListFile = ./deps.json;
  vendorHash = "sha256-Atm7zfnDambN/BmmUf4BG0yUz/y6xWzf0reDw3Ad41s=";
}
```

## Flutter applications {#ssec-dart-flutter}

The function `buildFlutterApplication` builds Flutter applications.

See the [Dart documentation](#ssec-dart-applications) for more details on required files and arguments.

```nix
{  flutter, fetchFromGitHub }:

flutter.buildFlutterApplication {
  pname = "firmware-updater";
  version = "unstable-2023-04-30";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "firmware-updater";
    rev = "6e7dbdb64e344633ea62874b54ff3990bd3b8440";
    sha256 = "sha256-s5mwtr5MSPqLMN+k851+pFIFFPa0N1hqz97ys050tFA=";
    fetchSubmodules = true;
  };

  pubspecLockFile = ./pubspec.lock;
  depsListFile = ./deps.json;
  vendorHash = "sha256-cdMO+tr6kYiN5xKXa+uTMAcFf2C75F3wVPrn21G4QPQ=";
}
```
