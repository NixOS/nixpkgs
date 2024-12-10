{
  lib,
  stdenv,
  callPackage,
  runCommand,
  writeText,
  pub2nix,
  dartHooks,
  makeWrapper,
  dart,
  nodejs,
  darwin,
  jq,
  yq,
}:

{
  src,
  sourceRoot ? "source",
  packageRoot ? (lib.removePrefix "/" (lib.removePrefix "source" sourceRoot)),
  gitHashes ? { },
  sdkSourceBuilders ? { },
  customSourceBuilders ? { },

  sdkSetupScript ? "",
  extraPackageConfigSetup ? "",

  # Output type to produce. Can be any kind supported by dart
  # https://dart.dev/tools/dart-compile#types-of-output
  # If using jit, you might want to pass some arguments to `dartJitFlags`
  dartOutputType ? "exe",
  dartCompileCommand ? "dart compile",
  dartCompileFlags ? [ ],
  # These come at the end of the command, useful to pass flags to the jit run
  dartJitFlags ? [ ],

  # Attrset of entry point files to build and install.
  # Where key is the final binary path and value is the source file path
  # e.g. { "bin/foo" = "bin/main.dart";  }
  # Set to null to read executables from pubspec.yaml
  dartEntryPoints ? null,
  # Used when wrapping aot, jit, kernel, and js builds.
  # Set to null to disable wrapping.
  dartRuntimeCommand ?
    if dartOutputType == "aot-snapshot" then
      "${dart}/bin/dartaotruntime"
    else if (dartOutputType == "jit-snapshot" || dartOutputType == "kernel") then
      "${dart}/bin/dart"
    else if dartOutputType == "js" then
      "${nodejs}/bin/node"
    else
      null,

  runtimeDependencies ? [ ],
  extraWrapProgramArgs ? "",

  autoPubspecLock ? null,
  pubspecLock ?
    if autoPubspecLock == null then
      throw "The pubspecLock argument is required. If import-from-derivation is allowed (it isn't in Nixpkgs), you can set autoPubspecLock to the path to a pubspec.lock instead."
    else
      assert lib.assertMsg (builtins.pathExists autoPubspecLock)
        "The pubspec.lock file could not be found!";
      lib.importJSON (
        runCommand "${lib.getName args}-pubspec-lock-json" {
          nativeBuildInputs = [ yq ];
        } ''yq . '${autoPubspecLock}' > "$out"''
      ),
  ...
}@args:

let
  generators = callPackage ./generators.nix { inherit dart; } { buildDrvArgs = args; };

  pubspecLockFile = builtins.toJSON pubspecLock;
  pubspecLockData = pub2nix.readPubspecLock {
    inherit
      src
      packageRoot
      pubspecLock
      gitHashes
      sdkSourceBuilders
      customSourceBuilders
      ;
  };
  packageConfig = generators.linkPackageConfig {
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
    extraSetupCommands = extraPackageConfigSetup;
  };

  inherit (dartHooks.override { inherit dart; })
    dartConfigHook
    dartBuildHook
    dartInstallHook
    dartFixupHook
    ;

  baseDerivation = stdenv.mkDerivation (
    finalAttrs:
    (builtins.removeAttrs args [
      "gitHashes"
      "sdkSourceBuilders"
      "pubspecLock"
      "customSourceBuilders"
    ])
    // {
      inherit
        pubspecLockFile
        packageConfig
        sdkSetupScript
        dartCompileCommand
        dartOutputType
        dartRuntimeCommand
        dartCompileFlags
        dartJitFlags
        ;

      outputs = [
        "out"
        "pubcache"
      ] ++ args.outputs or [ ];

      dartEntryPoints =
        if (dartEntryPoints != null) then
          writeText "entrypoints.json" (builtins.toJSON dartEntryPoints)
        else
          null;

      runtimeDependencies = map lib.getLib runtimeDependencies;

      nativeBuildInputs =
        (args.nativeBuildInputs or [ ])
        ++ [
          dart
          dartConfigHook
          dartBuildHook
          dartInstallHook
          dartFixupHook
          makeWrapper
          jq
        ]
        ++ lib.optionals stdenv.isDarwin [
          darwin.sigtool
        ]
        ++
          # Ensure that we inherit the propagated build inputs from the dependencies.
          builtins.attrValues pubspecLockData.dependencySources;

      preConfigure =
        args.preConfigure or ""
        + ''
          ln -sf "$pubspecLockFilePath" pubspec.lock
        '';

      # When stripping, it seems some ELF information is lost and the dart VM cli
      # runs instead of the expected program. Don't strip if it's an exe output.
      dontStrip = args.dontStrip or (dartOutputType == "exe");

      passAsFile = [ "pubspecLockFile" ];

      passthru = {
        pubspecLock = pubspecLockData;
      } // (args.passthru or { });

      meta = (args.meta or { }) // {
        platforms = args.meta.platforms or dart.meta.platforms;
      };
    }
  );
in
assert
  !(builtins.isString dartOutputType && dartOutputType != "")
  -> throw "dartOutputType must be a non-empty string";
baseDerivation
