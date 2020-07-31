{ stdenv, diffutils, dart, makeWrapper }:

{ pname
, version
# TODO Parse this from pubspec.yaml
, executables ? { }
, pubspecLock ? null
, pubSha256 ? "unset"
, pubCacheDir ? null
, dartFlags ? [ ]
, buildDir ? "build"
, buildType ? "release"
, src ? null
, srcs ? null
, ... }@args:

assert pubCacheDir == null -> pubSha256 != "unset";

assert (stdenv.lib.assertOneOf "buildType" buildType [ "release" "debug" ]);

assert (stdenv.lib.assertMsg (executables != { })
  "Missing 'executables' attribute; nothing to build!");

let

  copyLockFile = if pubspecLock != null then ''
    cp ${pubspecLock} "$sourceRoot/pubspec.lock"
    chmod +w "$sourceRoot/pubspec.lock"
  '' else ''
    if [ ! -f "$sourceRoot/pubspec.lock" ]; then
      echo
      echo "ERROR: Missing pubspec.lock from src."
      echo "Expected to find it at: $NIX_BUILD_TOP/$sourceRoot/pubspec.lock"
      echo
      echo "Hint: Pass a path to the lockfile in the pubspecLock atribute to add a pubspec.lock"
      echo "manually to the build."
      echo
      exit 1
    fi
  '';

  dartDeps = if pubCacheDir == null then
    let depsPname = "${pname}-deps";
    in (stdenv.mkDerivation rec {
      pname = depsPname;
      inherit version src srcs;

      nativeBuildInputs = [ dart ];

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = pubSha256;

      postUnpack = copyLockFile;

      buildPhase = ''
        mkdir .nix-pub-cache
        env PUB_CACHE=.nix-pub-cache ${dart}/bin/pub get --no-precompile
      '';

      installPhase = ''
        mkdir -p $out
        cp -R .nix-pub-cache/* $out
        cp pubspec.lock $out
      '';
    })
  else
    null;

  validateLockFile = pubSha256 != "unset";

  pubCache = if pubCacheDir == null then "${dartDeps}" else pubCacheDir;

  diff = "${diffutils.nativeDrv or diffutils}/bin/diff";

  dartOpts = with stdenv.lib;
    concatStringsSep " " ((optional (buildType == "debug") "--enable-asserts")
      ++ [ "-Dversion=${version}" ] ++ dartFlags);

  buildSnapshots = let
    inherit (stdenv.lib) concatStringsSep mapAttrsToList;
    buildSnapshot = name: path:
      with stdenv.lib; ''
        dart ${dartOpts} --snapshot="${buildDir}/${name}.snapshot" "bin/${path}.dart"
      '';
    steps = mapAttrsToList buildSnapshot executables;
  in concatStringsSep "\n" steps;

  installSnapshots = let
    inherit (builtins) attrNames;
    inherit (stdenv.lib) concatStringsSep mapAttrsToList;
    installSnapshot = name: ''
      cp "${buildDir}/${name}.snapshot" "$out/lib/dart/${pname}/"
      makeWrapper "${dart}/bin/dart" "$out/bin/${name}" \
        --argv0 "${name}" \
        --add-flags "$out/lib/dart/${pname}/${name}.snapshot"
    '';
    steps = map installSnapshot (attrNames executables);
  in concatStringsSep "\n" steps;

in stdenv.mkDerivation ((removeAttrs args [
  "executables"
  "pubspecLock"
  "sha256"
  "pubCacheDir"
  "dartFlags"
  "buildDir"
  "buildType"
]) // {

  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ dart makeWrapper ];
  buildInputs = (args.buildInputs or [ ]) ++ [ dart ];

  postUnpack = ''
    ${copyLockFile}
  '' + (args.postUnpack or "");

  postPatch = (args.postPatch or "")
    + stdenv.lib.optionalString validateLockFile ''
      dartDepsLockfile=${dartDeps}/pubspec.lock

      echo "Validating consistency between pubspec.lock and $dartDepsLockfile"
      if ! ${diff} pubspec.lock $dartDepsLockfile; then
        echo
        echo "ERROR: pubSha256 is out of date"
        echo
        echo "pubspec.lock is not the same in ${dartDeps}"
        echo
        echo "To fix the issue:"
        echo "1. Use stdenv.lib.fakeSha256 as the pubSha256 value"
        echo "2. Build the derivation and wait for it to fail with a hash mismatch"
        echo "3. Copy the 'got: sha256:' value back into the pubSha256 field"
        echo
        exit 1
      fi
    '';

  buildPhase = args.buildPhase or ''
    runHook preBuild

    mkdir -p "${buildDir}"

    (
    set -x
    export PUB_CACHE="${pubCache}"
    pub get --offline --no-precompile
    ${buildSnapshots}
    )

    runHook postBuild
  '';

  installPhase = args.installPhase or ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/dart/${pname}
    ${installSnapshots}

    runHook postInstall
  '';

  passthru = { inherit dartDeps; };

  meta = { platforms = dart.meta.platforms; } // (args.meta or { });
})
