{ lib, stdenv, fetchDartDeps, writeText, dartHooks, makeWrapper, dart, nodejs, darwin }:

{ pubGetScript ? "dart pub get"

  # Output type to produce. Can be any kind supported by dart
  # https://dart.dev/tools/dart-compile#types-of-output
  # If using jit, you might want to pass some arguments to `dartJitFlags`
, dartOutputType ? "exe"
, dartCompileCommand ? "dart compile"
, dartCompileFlags ? [ ]
  # These come at the end of the command, useful to pass flags to the jit run
, dartJitFlags ? [ ]

  # Attrset of entry point files to build and install.
  # Where key is the final binary path and value is the source file path
  # e.g. { "bin/foo" = "bin/main.dart";  }
  # Set to null to read executables from pubspec.yaml
, dartEntryPoints ? null
  # Used when wrapping aot, jit, kernel, and js builds.
  # Set to null to disable wrapping.
, dartRuntimeCommand ?
    if dartOutputType == "aot-snapshot" then "${dart}/bin/dartaotruntime"
    else if (dartOutputType == "jit-snapshot" || dartOutputType == "kernel") then "${dart}/bin/dart"
    else if dartOutputType == "js" then "${nodejs}/bin/node"
    else null

, pubspecLockFile ? null
, vendorHash ? ""
, ...
}@args:

let
  dartDeps = fetchDartDeps {
    buildDrvArgs = args;
    inherit pubGetScript vendorHash pubspecLockFile;
  };
  inherit (dartHooks.override { inherit dart; }) dartConfigHook dartBuildHook dartInstallHook;
in
assert !(builtins.isString dartOutputType && dartOutputType != "") ->
  throw "dartOutputType must be a non-empty string";
stdenv.mkDerivation (args // {
  inherit pubGetScript dartCompileCommand dartOutputType dartRuntimeCommand
    dartCompileFlags dartJitFlags;

    dartEntryPoints =
      if (dartEntryPoints != null)
      then writeText "entrypoints.json" (builtins.toJSON dartEntryPoints)
      else null;

  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
    dart
    dartDeps
    dartConfigHook
    dartBuildHook
    dartInstallHook
    makeWrapper
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.sigtool
  ];

  # When stripping, it seems some ELF information is lost and the dart VM cli
  # runs instead of the expected program. Don't strip if it's an exe output.
  dontStrip = args.dontStrip or (dartOutputType == "exe");

  passthru = { inherit dartDeps; } // (args.passthru or { });

  meta = (args.meta or { }) // { platforms = args.meta.platforms or dart.meta.platforms; };
})
