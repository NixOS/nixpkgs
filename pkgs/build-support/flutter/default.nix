{ lib
, stdenvNoCC
, llvmPackages_13
, cacert
, flutter
, git
}:

# absolutely no mac support for now

args:
let
  pl = n: "##FLUTTER_${n}_PLACEHOLDER_MARKER##";
  placeholder_deps = pl "DEPS";
  placeholder_flutter = pl "FLUTTER";
  fetchAttrs = [ "src" "sourceRoot" "setSourceRoot" "unpackPhase" "patches" ];
  getAttrsOrNull = names: attrs: lib.genAttrs names (name: if attrs ? ${name} then attrs.${name} else null);
  self =
(self: llvmPackages_13.stdenv.mkDerivation (args // {
  deps = stdenvNoCC.mkDerivation (lib.recursiveUpdate (getAttrsOrNull fetchAttrs args) {
    name = "${self.name}-deps-flutter";

    nativeBuildInputs = [
      flutter
      git
    ];

    # avoid pub phase
    dontBuild = true;

    installPhase = ''
      TMP=$(mktemp -d)
      export HOME="$TMP"

      # Configure the package cache
      export PUB_CACHE="$out/cache/.pub-cache"
      mkdir -p "$PUB_CACHE"

      flutter config --no-analytics &>/dev/null # mute first-run
      flutter config --enable-linux-desktop
      flutter packages get
      ${lib.optionalString (args ? flutterExtraFetchCommands) args.flutterExtraFetchCommands}

      # so we can use lock, diff yaml
      mkdir -p "$out/pubspec"
      cp "pubspec.yaml" "$out/pubspec"
      cp "pubspec.lock" "$out/pubspec"

      # nuke nondeterminism

      # Remove Git directories in the Git package cache - these are rarely used by Pub,
      # which instead maintains a corresponsing mirror and clones cached packages through it.
      find "$PUB_CACHE" -name .git -type d -prune -exec rm -rf {} +

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
      "GIT_PROXY_COMMAND" "NIX_GIT_SSL_CAINFO" "SOCKS_SERVER"
    ];

    # unnecesarry
    dontFixup = true;

    # Patching shebangs introduces input references to this fixed-output derivation.
    # This triggers a bug in Nix, causing the output path to change unexpectedly.
    # https://github.com/NixOS/nix/issues/6660
    dontPatchShebangs = true;

    outputHashAlgo = if self ? vendorHash then null else "sha256";
    outputHashMode = "recursive";
    outputHash = if self ? vendorHash then
      self.vendorHash
    else if self ? vendorSha256 then
      self.vendorSha256
    else
      lib.fakeSha256;
  });

  nativeBuildInputs = [
    flutter
    git
  ] ++ lib.optionals (args ? nativeBuildInputs) args.nativeBuildInputs;

  buildInputs = lib.optionals (args ? buildInputs) args.buildInputs;

  configurePhase = ''
    runHook preConfigure

    TMP=$(mktemp -d)
    export HOME="$TMP"

    flutter config --no-analytics &>/dev/null # mute first-run
    flutter config --enable-linux-desktop

    # Configure the package cache
    export PUB_CACHE="$TMP/.pub-cache"
    mkdir -p "$PUB_CACHE"

    # Link the Git package cache.
    mkdir -p "$PUB_CACHE/git"
    ln -s "$deps/cache/.pub-cache/git"/* "$PUB_CACHE/git"

    # Recreate the internal Git cache subdirectory.
    # See: https://github.com/dart-lang/pub/blob/c890afa1d65b340fa59308172029680c2f8b0fc6/lib/src/source/git.dart#L339)
    # Blank repositories are created instead of attempting to match the cache mirrors to checkouts.
    # This is not an issue, as pub does not need the mirrors in the Flutter build process.
    rm "$PUB_CACHE/git/cache" && mkdir "$PUB_CACHE/git/cache"
    for mirror in $(ls -A "$deps/cache/.pub-cache/git/cache"); do
      git --git-dir="$PUB_CACHE/git/cache/$mirror" init --bare --quiet
    done

    # Link the remaining package cache directories.
    # At this point, any subdirectories that must be writable must have been taken care of.
    for file in $(comm -23 <(ls -A "$deps/cache/.pub-cache") <(ls -A "$PUB_CACHE")); do
      ln -s "$deps/cache/.pub-cache/$file" "$PUB_CACHE/$file"
    done

    # ensure we're using a lockfile for the right package version
    if [ -e pubspec.lock ]; then
      # FIXME: currently this is broken. in theory this should not break, but flutter has it's own way of doing things.
      # diff -u pubspec.lock "$deps/pubspec/pubspec.lock"
      true
    else
      cp -v "$deps/pubspec/pubspec.lock" .
      # Sometimes the pubspec.lock will get opened in write mode, even when offline.
      chmod u+w pubspec.lock
    fi
    diff -u pubspec.yaml "$deps/pubspec/pubspec.yaml"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p build/flutter_assets/fonts

    flutter packages get --offline -v
    flutter build linux --release -v

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    built=build/linux/*/release/bundle

    mkdir -p $out/bin
    mv $built $out/app

    for f in $(find $out/app -iname "*.desktop" -type f); do
      install -D $f $out/share/applications/$(basename $f)
    done

    for f in $(find $out/app -maxdepth 1 -type f); do
      ln -s $f $out/bin/$(basename $f)
    done

    # make *.so executable
    find $out/app -iname "*.so" -type f -exec chmod +x {} +

    # remove stuff like /build/source/packages/ubuntu_desktop_installer/linux/flutter/ephemeral
    for f in $(find $out/app -executable -type f); do
      if patchelf --print-rpath "$f" | grep /build; then # this ignores static libs (e,g. libapp.so) also
        echo "strip RPath of $f"
        newrp=$(patchelf --print-rpath $f | sed -r "s|/build.*ephemeral:||g" | sed -r "s|/build.*profile:||g")
        patchelf --set-rpath "$newrp" "$f"
      fi
    done

    runHook postInstall
  '';
})) self;
in
  self
