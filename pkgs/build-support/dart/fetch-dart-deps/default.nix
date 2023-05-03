{ stdenvNoCC
, lib
, makeSetupHook
, dart
, git
, cacert
, jq
}:

{
  # The output hash of the dependencies for this project.
  vendorHash ? ""
  # Commands to run once before using Dart or pub.
, sdkSetupScript ? ""
  # Commands to run to populate the pub cache.
, pubGetScript ? "dart pub get"
  # A path to a pubspec.lock file to use instead of the one in the source directory.
, pubspecLockFile ? null
  # Arguments used in the derivation that builds the Dart package.
  # Passing these is recommended to ensure that the same steps are made to prepare the sources in both this
  # derivation and the one that builds the Dart package.
, buildDrvArgs ? { }
, ...
}@args:

# This is a fixed-output derivation and setup hook that can be used to fetch dependencies for Dart projects.
# It is designed to be placed in the nativeBuildInputs of a derivation that builds a Dart package.
# Providing the buildDrvArgs argument is highly recommended.
let
  buildDrvInheritArgNames = [
    "name"
    "pname"
    "version"
    "src"
    "sourceRoot"
    "setSourceRoot"
    "preUnpack"
    "unpackPhase"
    "unpackCmd"
    "postUnpack"
    "prePatch"
    "patchPhase"
    "patches"
    "patchFlags"
    "postPatch"
  ];

  buildDrvInheritArgs = builtins.foldl'
    (attrs: arg:
      if buildDrvArgs ? ${arg}
      then attrs // { ${arg} = buildDrvArgs.${arg}; }
      else attrs)
    { }
    buildDrvInheritArgNames;

  drvArgs = buildDrvInheritArgs // (removeAttrs args [ "buildDrvArgs" ]);
  name = (if drvArgs ? name then drvArgs.name else "${drvArgs.pname}-${drvArgs.version}");

  deps =
    stdenvNoCC.mkDerivation ({
      name = "${name}-dart-deps";

      nativeBuildInputs = [
        dart
        git
      ];

      # avoid pub phase
      dontBuild = true;

      configurePhase = ''
        # Configure the package cache
        export PUB_CACHE="$out/cache/.pub-cache"
        mkdir -p "$PUB_CACHE"

        ${sdkSetupScript}
      '';

      installPhase = ''
        _pub_get() {
          ${pubGetScript}
        }

        # so we can use lock, diff yaml
        mkdir -p "$out/pubspec"
        cp "pubspec.yaml" "$out/pubspec"
        ${lib.optionalString (pubspecLockFile != null) "install -m644 ${pubspecLockFile} pubspec.lock"}
        if ! cp "pubspec.lock" "$out/pubspec"; then
          echo 1>&2 -e '\nThe pubspec.lock file is missing. This is a requirement for reproducible builds.' \
                       '\nThe following steps should be taken to fix this issue:' \
                       '\n  1. If you are building an application, contact the developer(s).' \
                       '\n     The pubspec.lock file should be provided with the source code.' \
                       '\n     https://dart.dev/guides/libraries/private-files#pubspeclock' \
                       '\n  2. An attempt to generate and print a compressed pubspec.lock file will be made now.' \
                       '\n     It is compressed with gzip and base64 encoded.' \
                       '\n     Paste it to a file and extract it with `base64 -d pubspec.lock.in | gzip -d > pubspec.lock`.' \
                       '\n     Provide the path to the pubspec.lock file in the pubspecLockFile argument.' \
                       '\n     This must be updated whenever the application is updated.' \
                       '\n'
          _pub_get
          echo ""
          gzip --to-stdout --best pubspec.lock | base64 1>&2
          echo 1>&2 -e '\nA gzipped pubspec.lock file has been printed. Please see the informational message above.'
          exit 1
        fi

        _pub_get

        # nuke nondeterminism

        # Remove Git directories in the Git package cache - these are rarely used by Pub,
        # which instead maintains a corresponsing mirror and clones cached packages through it.
        #
        # An exception is made to keep .git/pub-packages files, which are important.
        # https://github.com/dart-lang/pub/blob/c890afa1d65b340fa59308172029680c2f8b0fc6/lib/src/source/git.dart#L621
        if [ -d "$PUB_CACHE"/git ]; then
          find "$PUB_CACHE"/git -maxdepth 4 -path "*/.git/*" ! -name "pub-packages" -prune -exec rm -rf {} +
        fi

        # Remove continuously updated package metadata caches
        rm -rf "$PUB_CACHE"/hosted/*/.cache # Not pinned by pubspec.lock
        rm -rf "$PUB_CACHE"/git/cache/*/* # Recreate this on the other end. See: https://github.com/dart-lang/pub/blob/c890afa1d65b340fa59308172029680c2f8b0fc6/lib/src/source/git.dart#L531

        # Miscelaneous transient package cache files
        rm -f "$PUB_CACHE"/README.md # May change with different Dart versions
        rm -rf "$PUB_CACHE"/_temp # https://github.com/dart-lang/pub/blob/c890afa1d65b340fa59308172029680c2f8b0fc6/lib/src/system_cache.dart#L131
        rm -rf "$PUB_CACHE"/log # https://github.com/dart-lang/pub/blob/c890afa1d65b340fa59308172029680c2f8b0fc6/lib/src/command.dart#L348
      '';

      GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
        "GIT_PROXY_COMMAND"
        "NIX_GIT_SSL_CAINFO"
        "SOCKS_SERVER"
      ];

      # Patching shebangs introduces input references to this fixed-output derivation.
      # This triggers a bug in Nix, causing the output path to change unexpectedly.
      # https://github.com/NixOS/nix/issues/6660
      dontPatchShebangs = true;

      # The following operations are not generally useful for this derivation.
      # If a package does contain some native components used at build time,
      # please file an issue.
      dontStrip = true;
      dontMoveSbin = true;
      dontPatchELF = true;

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash = if vendorHash != "" then vendorHash else lib.fakeSha256;
    } // (removeAttrs drvArgs [ "name" "pname" ]));

  depsListDrv = stdenvNoCC.mkDerivation ({
    name = "${name}-dart-deps-list.json";
    nativeBuildInputs = [ hook dart jq ];

    configurePhase = ''
      runHook preConfigure
      dart pub get --offline
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      dart pub deps --json | jq .packages > $out
      runHook postBuild
    '';
  } // buildDrvInheritArgs);

  hook = (makeSetupHook {
    # The setup hook should not be part of the fixed-output derivation.
    # Updates to the hook script should not change vendor hashes, and it won't
    # work at all anyway due to https://github.com/NixOS/nix/issues/6660.
    name = "${name}-dart-deps-setup-hook";
    substitutions = { inherit deps; };
    propagatedBuildInputs = [ dart git ];
    passthru = {
      files = deps.outPath;
      depsListFile = depsListDrv.outPath;
    };
  }) ./setup-hook.sh;
in
hook
