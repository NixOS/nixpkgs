{ flutter
, lib
, llvmPackages_13
, cmake
, ninja
, pkg-config
, wrapGAppsHook
, autoPatchelfHook
, util-linux
, libselinux
, libsepol
, libthai
, libdatrie
, libxkbcommon
, at-spi2-core
, libsecret
, jsoncpp
, xorg
, dbus
, gtk3
, glib
, pcre
, libepoxy
, stdenvNoCC
, cacert
, git
, dart
, nukeReferences
, bash
, curl
, unzip
, which
, xz
, callPackage
}:

# absolutely no mac support for now

args:
let
  pl = n: "##FLUTTER_${n}_PLACEHOLDER_MARKER##";
  placeholder_deps = pl "DEPS";
  placeholder_flutter = pl "FLUTTER";
  fetchAttrs = [ "src" "sourceRoot" "setSourceRoot" "unpackPhase" "patches" ];
  getAttrsOrNull = names: attrs: lib.genAttrs names (name: if attrs ? ${name} then attrs.${name} else null);
  flutterDeps = [
    # flutter deps
    flutter.unwrapped
    bash
    curl
    flutter.dart
    git
    unzip
    which
    xz
  ];
  mkFlutterDeps = callPackage ./mkFlutterDeps.nix {};
  self =
(self: llvmPackages_13.stdenv.mkDerivation (args // {
  deps = mkFlutterDeps (lib.recursiveUpdate (getAttrsOrNull fetchAttrs args) {
    inherit placeholder_deps placeholder_flutter flutterDeps;
    appName = self.name;
    outputHashAlgo = if self ? vendorHash then null else "sha256";
    # outputHashMode = "recursive";
    outputHash = if self ? vendorHash then
      self.vendorHash
    else if self ? vendorSha256 then
      self.vendorSha256
    else
      lib.fakeSha256;
  });

  nativeBuildInputs = flutterDeps ++ [
    # flutter dev tools
    cmake
    ninja
    pkg-config
    wrapGAppsHook
    # flutter likes dynamic linking
    autoPatchelfHook
  ] ++ lib.optionals (args ? nativeBuildInputs) args.nativeBuildInputs;

  buildInputs = [
    # cmake deps
    gtk3
    glib
    pcre
    util-linux
    # also required by cmake, not sure if really needed or dep of all packages
    libselinux
    libsepol
    libthai
    libdatrie
    xorg.libXdmcp
    xorg.libXtst
    libxkbcommon
    dbus
    at-spi2-core
    libsecret
    jsoncpp
    # build deps
    xorg.libX11
    # directly required by build
    libepoxy
  ] ++ lib.optionals (args ? buildInputs) args.buildInputs;

  # TODO: do we need this?
  NIX_LDFLAGS = "-rpath ${lib.makeLibraryPath self.buildInputs}";
  env.NIX_CFLAGS_COMPILE = "-I${xorg.libX11}/include";
  LD_LIBRARY_PATH = lib.makeLibraryPath self.buildInputs;

  configurePhase = ''
    runHook preConfigure

    # for some reason fluffychat build breaks without this - seems file gets overriden by some tool
    cp pubspec.yaml pubspec-backup

    # we get this from $depsFolder so disabled for now, but we might need it again once deps are fetched properly
    # flutter config --no-analytics >/dev/null 2>/dev/null # mute first-run
    # flutter config --enable-linux-desktop

    # extract deps
    depsFolder=$(mktemp -d)
    tar xzf "$deps" -C "$depsFolder"

    # after extracting update paths to point to real paths
    find "$depsFolder" -type f -exec sed -i \
      -e s,${placeholder_deps},$depsFolder,g \
      -e s,${placeholder_flutter},${flutter.unwrapped},g \
      {} +

    # ensure we're using a lockfile for the right package version
    if [ -e pubspec.lock ]; then
      # FIXME: currently this is broken. in theory this should not break, but flutter has it's own way of doing things.
      # diff -u pubspec.lock $depsFolder/pubspec.lock
      true
    else
      cp -v "$depsFolder/pubspec.lock" .
    fi
    diff -u pubspec.yaml $depsFolder/pubspec.yaml

    mv -v $(find $depsFolder/f -type f) .

    # prepare
    export HOME=$depsFolder
    export PUB_CACHE=''${PUB_CACHE:-"$HOME/.pub-cache"}
    export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1

    # binaries need to be patched
    autoPatchelf -- "$depsFolder"

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

    # this confuses autopatchelf hook otherwise
    rm -rf "$depsFolder"

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
