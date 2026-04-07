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
  yq-go,
}:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [
    "gitHashes"
    "sdkSourceBuilders"
    "pubspecLock"
    "customSourceBuilders"
  ];

  extendDrvArgs =
    finalAttrs:
    args@{
      src,
      sourceRoot ? src.name,
      packageRoot ? (
        (p: if p == "" then "." else p) (lib.removePrefix "/" (lib.removePrefix src.name sourceRoot))
      ),
      gitHashes ? { },
      sdkSourceBuilders ? { },
      customSourceBuilders ? { },

      sdkSetupScript ? "",

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
          (lib.getExe' dart "dartaotruntime")
        else if (dartOutputType == "jit-snapshot" || dartOutputType == "kernel") then
          (lib.getExe dart)
        else if dartOutputType == "js" then
          (lib.getExe nodejs)
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
              nativeBuildInputs = [ yq-go ];
            } ''yq eval --output-format=json --prettyPrint '${autoPubspecLock}' > "$out"''
          ),
      ...
    }:
    let
      pubspecLockData = pub2nix.readPubspecLock {
        inherit
          src
          packageRoot
          pubspecLock
          gitHashes
          customSourceBuilders
          ;
        sdkSourceBuilders = {
          # https://github.com/dart-lang/pub/blob/e1fbda73d1ac597474b82882ee0bf6ecea5df108/lib/src/sdk/dart.dart#L80
          "dart" =
            name:
            runCommand "dart-sdk-${name}" { passthru.packageRoot = "."; } ''
              for path in '${dart}/pkg/${name}'; do
                if [ -d "$path" ]; then
                  ln --symbolic "$path" "$out"
                  break
                fi
              done

              if[ ! -e "$out" ]; then
                echo 1>&2 'The Dart SDK does not contain the requested package: ${name}!'
                exit 1
              fi
            '';
        }
        // sdkSourceBuilders;
      };

      inherit (dartHooks.override { inherit dart; })
        dartConfigHook
        dartBuildHook
        dartInstallHook
        dartFixupHook
        ;

    in
    assert
      !(builtins.isString dartOutputType && dartOutputType != "")
      -> throw "dartOutputType must be a non-empty string";

    (builtins.removeAttrs args [
      "gitHashes"
      "sdkSourceBuilders"
      "pubspecLock"
      "customSourceBuilders"
    ])
    // {
      inherit
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
      ]
      ++ args.outputs or [ ];

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
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          darwin.sigtool
        ]
        ++ (lib.filter (d: d ? setupHook || d ? propagatedBuildInputs) (
          lib.attrValues pubspecLockData.dependencySources
        ));

      env = (args.env or { }) // {
        pubDeps = writeText "pub-dependencies.json" (
          builtins.toJSON (
            lib.genAttrs
              (
                # Ideally, we'd only include the main dependencies and their transitive
                # dependencies.
                #
                # The pubspec.lock file does not contain information about where
                # transitive dependencies come from, though, and it would be weird to
                # include the transitive dependencies of dev and override dependencies
                # without including the dev and override dependencies themselves.
                builtins.concatLists (builtins.attrValues pubspecLockData.dependencies)
              )
              (dependency: {
                src = "${pubspecLockData.dependencySources.${dependency}}";
                inherit (pubspecLockData.dependencySources.${dependency}) packageRoot;
              })
          )
        );
      };

      # When stripping, it seems some ELF information is lost and the dart VM cli
      # runs instead of the expected program. Don't strip if it's an exe output.
      dontStrip = args.dontStrip or (dartOutputType == "exe");

      passthru = {
        pubspecLock = pubspecLockData;
      }
      // (args.passthru or { });

      meta = (args.meta or { }) // {
        platforms = args.meta.platforms or dart.meta.platforms;
      };
    };
}
