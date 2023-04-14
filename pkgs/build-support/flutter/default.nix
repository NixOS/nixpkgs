{ lib
, stdenvNoCC
, nukeReferences
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
    name = "${self.name}-deps-flutter-v${flutter.unwrapped.version}.tar.gz";

    nativeBuildInputs = [
      flutter
      git
      nukeReferences
    ];

    # avoid pub phase
    dontBuild = true;

    installPhase = ''
      . ${../fetchgit/deterministic-git}

      TMP=$(mktemp -d)
      export HOME="$TMP"

      flutter config --no-analytics &>/dev/null # mute first-run
      flutter config --enable-linux-desktop
      flutter packages get
      ${lib.optionalString (args ? flutterExtraFetchCommands) args.flutterExtraFetchCommands}

      RES="$TMP"

      # so we can use lock, diff yaml
      cp "pubspec.yaml" "$RES"
      cp "pubspec.lock" "$RES"

      # replace paths with placeholders
      find "$RES" -type f -exec sed -i \
        -e s,$TMP,${placeholder_deps},g \
        -e s,${flutter.unwrapped},${placeholder_flutter},g \
        {} +

      # nuke nondeterminism

      # deterministic git repos
      find "$RES" -iname .git -type d | while read -r repoGit; do
        make_deterministic_repo "$(dirname "$repoGit")"
      done

      # Impure Pub files
      rm -rf "$RES"/.pub-cache/hosted/*/.cache # Not pinned by pubspec.lock
      rm -f "$RES"/.pub-cache/README.md # May change with different Dart versions

      # nuke refs
      find "$RES" -type f -exec nuke-refs {} +

      # Build a reproducible tar, per instructions at https://reproducible-builds.org/docs/archives/
      tar --owner=0 --group=0 --numeric-owner --format=gnu \
          --sort=name --mtime="@$SOURCE_DATE_EPOCH" \
          -czf "$out" -C "$RES" \
          pubspec.yaml pubspec.lock .pub-cache
    '';

    GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND" "NIX_GIT_SSL_CAINFO" "SOCKS_SERVER"
    ];

    # unnecesarry
    dontFixup = true;

    outputHashAlgo = if self ? vendorHash then null else "sha256";
    # outputHashMode = "recursive";
    outputHash = if self ? vendorHash then
      self.vendorHash
    else if self ? vendorSha256 then
      self.vendorSha256
    else
      lib.fakeSha256;

  });

  nativeBuildInputs = [ flutter ] ++ lib.optionals (args ? nativeBuildInputs) args.nativeBuildInputs;

  buildInputs = lib.optionals (args ? buildInputs) args.buildInputs;

  configurePhase = ''
    runHook preConfigure

    # for some reason fluffychat build breaks without this - seems file gets overriden by some tool
    cp pubspec.yaml pubspec-backup

    TMP=$(mktemp -d)
    export HOME="$TMP"

    flutter config --no-analytics &>/dev/null # mute first-run
    flutter config --enable-linux-desktop

    # extract deps
    tar xzf "$deps" -C "$HOME"

    # after extracting update paths to point to real paths
    find "$HOME" -type f -exec sed -i \
      -e s,${placeholder_deps},"$HOME",g \
      -e s,${placeholder_flutter},${flutter},g \
      {} +

    # ensure we're using a lockfile for the right package version
    if [ -e pubspec.lock ]; then
      # FIXME: currently this is broken. in theory this should not break, but flutter has it's own way of doing things.
      # diff -u pubspec.lock "$HOME/pubspec.lock"
      true
    else
      cp -v "$HOME/pubspec.lock" .
    fi
    diff -u pubspec.yaml "$HOME/pubspec.yaml"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # for some reason fluffychat build breaks without this - seems file gets overriden by some tool
    mv pubspec-backup pubspec.yaml
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
