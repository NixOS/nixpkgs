{ lib
, stdenv
, callPackage
, writeText
, pub2nix
, dartHooks
, makeWrapper
, dart
, nodejs
, darwin
, jq
}:

{ src
, sourceRoot ? "source"
, packageRoot ? (lib.removePrefix "/" (lib.removePrefix "source" sourceRoot))
, gitHashes ? { }
, sdkSourceBuilders ? { }

, sdkSetupScript ? ""
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
, pubspecLock
, ...
}@args:

let
  generators = callPackage ./generators.nix { inherit dart; } { inherit sdkSetupScript; buildDrvArgs = args; };

  depsList = if depsListFile == null then null else lib.importJSON depsListFile;
  generatedDepsList = generators.mkDepsList { inherit pubspecLockFile pubspecLockData packageConfig; };

  pubspecLockFile = builtins.toJSON pubspecLock;
  pubspecLockData = pub2nix.readPubspecLock { inherit src packageRoot pubspecLock gitHashes sdkSourceBuilders; };
  packageConfig = pub2nix.generatePackageConfig {
    pname = if args.pname != null then "${args.pname}-${args.version}" else null;

    dependencies =
      # Ideally, we'd only include the main dependencies and their transitive
      # dependencies.
      #
      # The pubspec.lock file does not contain information about where
      # transitive dependencies come from, though, and it would be weird to
      # include the transitive dependencies of dev and override dependencies
      # without including the dev and override dependencies themselves.
      builtins.concatLists (builtins.attrValues pubspecLockData.dependencies);

    inherit (pubspecLockData) dependencySources;
  };

  inherit (dartHooks.override { inherit dart; }) dartConfigHook dartBuildHook dartInstallHook dartFixupHook;

  baseDerivation = stdenv.mkDerivation (finalAttrs: (builtins.removeAttrs args [ "gitHashes" "sdkSourceBuilders" "pubspecLock" ]) // {
    inherit pubspecLockFile packageConfig sdkSetupScript pubGetScript
      dartCompileCommand dartOutputType dartRuntimeCommand dartCompileFlags
      dartJitFlags runtimeDependencies;

    outputs = args.outputs or [ ] ++ [ "out" "pubcache" ];

    dartEntryPoints =
      if (dartEntryPoints != null)
      then writeText "entrypoints.json" (builtins.toJSON dartEntryPoints)
      else null;

    runtimeDependencyLibraryPath = lib.makeLibraryPath finalAttrs.runtimeDependencies;

    nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
      dart
      dartConfigHook
      dartBuildHook
      dartInstallHook
      dartFixupHook
      makeWrapper
      jq
    ] ++ lib.optionals stdenv.isDarwin [
      darwin.sigtool
    ];

    preConfigure = args.preConfigure or "" + ''
      ln -sf "$pubspecLockFilePath" pubspec.lock
    '';

    preBuild = args.preBuild or "" + lib.optionalString (!autoDepsList) ''
      if ! { [ '${lib.boolToString (depsListFile != null)}' = 'true' ] ${lib.optionalString (depsListFile != null) "&& cmp -s <(jq -Sc . '${depsListFile}') <(jq -Sc . deps.json)"}; }; then
        echo 1>&2 -e '\nThe dependency list file was either not given or differs from the expected result.' \
                     '\nPlease choose one of the following solutions:' \
                     '\n - Duplicate the following file and pass it to the depsListFile argument.' \
                     '\n   ${generatedDepsList}' \
                     '\n - Set autoDepsList to true (not supported by Hydra or permitted in Nixpkgs)'.
        exit 1
      fi
    '';

    # When stripping, it seems some ELF information is lost and the dart VM cli
    # runs instead of the expected program. Don't strip if it's an exe output.
    dontStrip = args.dontStrip or (dartOutputType == "exe");

    passAsFile = [ "pubspecLockFile" ];

    passthru = {
      pubspecLock = pubspecLockData;
      depsList = generatedDepsList;
      generatePubspecLock = generators.generatePubspecLock { inherit pubGetScript; };
    } // (args.passthru or { });

    meta = (args.meta or { }) // { platforms = args.meta.platforms or dart.meta.platforms; };
  });

  packageOverrideRepository = (callPackage ../../../development/compilers/dart/package-overrides { }) // customPackageOverrides;
  productPackages = builtins.filter (package: package.kind != "dev")
    (if autoDepsList
    then lib.importJSON generatedDepsList
    else if depsList == null then [ ] else depsList);
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
