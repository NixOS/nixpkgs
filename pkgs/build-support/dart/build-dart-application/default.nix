{ lib, stdenv, callPackage, fetchDartDeps, runCommand, symlinkJoin, writeText, dartHooks, makeWrapper, dart, cacert, nodejs, darwin, jq }:

{ sdkSetupScript ? ""
, pubGetScript ? "dart pub get"

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
, dartRuntimeCommand ? if dartOutputType == "aot-snapshot" then "${dart}/bin/dartaotruntime"
  else if (dartOutputType == "jit-snapshot" || dartOutputType == "kernel") then "${dart}/bin/dart"
  else if dartOutputType == "js" then "${nodejs}/bin/node"
  else null

, runtimeDependencies ? [ ]
, extraWrapProgramArgs ? ""
, customPackageOverrides ? { }
, autoDepsList ? false
, depsListFile ? null
, pubspecLockFile ? null
, vendorHash ? ""
, ...
}@args:

let
  dartDeps = (fetchDartDeps.override {
    dart = symlinkJoin {
      name = "dart-sdk-fod";
      paths = [
        (runCommand "dart-fod" { nativeBuildInputs = [ makeWrapper ]; } ''
          mkdir -p "$out/bin"
          makeWrapper "${dart}/bin/dart" "$out/bin/dart" \
            --add-flags "--root-certs-file=${cacert}/etc/ssl/certs/ca-bundle.crt"
        '')
        dart
      ];
    };
  }) {
    buildDrvArgs = args;
    inherit sdkSetupScript pubGetScript vendorHash pubspecLockFile;
  };
  inherit (dartHooks.override { inherit dart; }) dartConfigHook dartBuildHook dartInstallHook dartFixupHook;

  baseDerivation = stdenv.mkDerivation (finalAttrs: args // {
    inherit sdkSetupScript pubGetScript dartCompileCommand dartOutputType
      dartRuntimeCommand dartCompileFlags dartJitFlags runtimeDependencies;

    dartEntryPoints =
      if (dartEntryPoints != null)
      then writeText "entrypoints.json" (builtins.toJSON dartEntryPoints)
      else null;

    runtimeDependencyLibraryPath = lib.makeLibraryPath finalAttrs.runtimeDependencies;

    nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
      dart
      dartDeps
      dartConfigHook
      dartBuildHook
      dartInstallHook
      dartFixupHook
      makeWrapper
      jq
    ] ++ lib.optionals stdenv.isDarwin [
      darwin.sigtool
    ];

    preUnpack = ''
      ${lib.optionalString (!autoDepsList) ''
        if ! { [ '${lib.boolToString (depsListFile != null)}' = 'true' ] ${lib.optionalString (depsListFile != null) "&& cmp -s <(jq -Sc . '${depsListFile}') <(jq -Sc . '${finalAttrs.passthru.dartDeps.depsListFile}')"}; }; then
          echo 1>&2 -e '\nThe dependency list file was either not given or differs from the expected result.' \
                      '\nPlease choose one of the following solutions:' \
                      '\n - Duplicate the following file and pass it to the depsListFile argument.' \
                      '\n   ${finalAttrs.passthru.dartDeps.depsListFile}' \
                      '\n - Set autoDepsList to true (not supported by Hydra or permitted in Nixpkgs)'.
          exit 1
        fi
      ''}
      ${args.preUnpack or ""}
    '';

    # When stripping, it seems some ELF information is lost and the dart VM cli
    # runs instead of the expected program. Don't strip if it's an exe output.
    dontStrip = args.dontStrip or (dartOutputType == "exe");

    passthru = { inherit dartDeps; } // (args.passthru or { });

    meta = (args.meta or { }) // { platforms = args.meta.platforms or dart.meta.platforms; };
  });

  packageOverrideRepository = (callPackage ../../../development/compilers/dart/package-overrides { }) // customPackageOverrides;
  productPackages = builtins.filter (package: package.kind != "dev")
    (if autoDepsList
    then lib.importJSON dartDeps.depsListFile
    else
      if depsListFile == null
      then [ ]
      else lib.importJSON depsListFile);
in
assert !(builtins.isString dartOutputType && dartOutputType != "") ->
throw "dartOutputType must be a non-empty string";
builtins.foldl'
  (prev: package:
  if packageOverrideRepository ? ${package.name}
  then
    prev.overrideAttrs
      (packageOverrideRepository.${package.name} {
        inherit (package)
          name
          version
          kind
          source
          dependencies;
      })
  else prev)
  baseDerivation
  productPackages
