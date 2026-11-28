{
  stdenv,
  lib,
  makeBinaryWrapper,
  fetchurl,
  writeShellScript,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  zulu21,
  dpkg,
  zip,
  unzip,
  patchelf,
  gnupg,
  coreutils,
  util-linux,

  # The libraries which the Tor expert bundle of the .deb expects from the
  # distribution; see buildPhase.
  glibc,
  zlib,

  # Native libraries required by the JavaFX natives that Bisq extracts from its bundled
  # javafx-graphics jar into ~/.openjfx/cache at runtime. Those .so files are
  # bare (no rpath), so every direct needed library must be on LD_LIBRARY_PATH.
  # The set below is exactly the verified closure (readelf NEEDED + ldd not_found=0).
  gtk3,
  glib,
  cairo,
  pango,
  atk,
  gdk-pixbuf,
  harfbuzz,
  freetype,
  fontconfig,
  libGL,
  libglvnd,
  libx11,
  libxtst,
  libxxf86vm,
}:

let
  # This is separated into its own file so it's easier for `update.sh`.
  sources = import ./sources.nix;

  version = sources.version;

  # JDK 21 is the toolchain required by docs/build.md. enableJavaFX is not
  # strictly required (Bisq bundles its own JavaFX jars), but mirrors the
  # sibling bisq2 package and gives a JDK that can host JavaFX.
  jdk = zulu21.override {
    enableJavaFX = true;
  };

  # JVM arguments sourced from bisq/desktop/build.gradle, applicationDefaultJvmArgs
  bisqJvmArgs = lib.concatStringsSep " " [
    "-XX:MaxRAM=8g"
    "-Xss1280k"
    "-XX:+UseG1GC"
    "-XX:MaxHeapFreeRatio=10"
    "-XX:MinHeapFreeRatio=5"
    "-XX:+UseStringDeduplication"
    "-Djava.net.preferIPv4Stack=true"
    "--add-opens=javafx.controls/javafx.scene.control.skin=ALL-UNNAMED"
  ];

  # JVM arguments added for nixpkgs, not present in the bisq source tree.
  nixpkgsJvmArgs = lib.concatStringsSep " " [
    # solving this error at application startup:
    # > class com.jfoenix.skins.JFXSpinnerSkin (in unnamed module @0x77ec78b9) cannot access class com.sun.javafx.scene.NodeHelper (in module javafx.graphics) because module javafx.graphics does not export com.sun.javafx.scene to unnamed module @0x77ec78b9
    "--add-exports=javafx.graphics/com.sun.javafx.scene=ALL-UNNAMED"

    # solving this error at application startup:
    # > class com.jfoenix.skins.JFXTabPaneSkin$TabHeaderContainer (in unnamed module @0x77ec78b9) cannot access class com.sun.javafx.scene.control.LambdaMultiplePropertyChangeListenerHandler (in module javafx.controls) because module javafx.controls does not export com.sun.javafx.scene.control to unnamed module @0x77ec78b9
    "--add-exports=javafx.controls/com.sun.javafx.scene.control=ALL-UNNAMED"

    # solving this error at application startup:
    # > class com.jfoenix.skins.JFXTabPaneSkin (in unnamed module @0x77ec78b9) cannot access class com.sun.javafx.scene.control.behavior.TabPaneBehavior (in module javafx.controls) because module javafx.controls does not export com.sun.javafx.scene.control.behavior to unnamed module @0x77ec78b9
    "--add-exports=javafx.controls/com.sun.javafx.scene.control.behavior=ALL-UNNAMED"
  ];

  bisq-launcher =
    args:
    writeShellScript "bisq-launcher" ''
      exec "${lib.getExe jdk}" \
        ${bisqJvmArgs} \
        ${nixpkgsJvmArgs} \
        -classpath @out@/lib/app/desktop.jar:@out@/lib/app/* \
        ${args} bisq.desktop.app.BisqAppMain "$@"
    '';

  # keys taken from bisq/docs/release-process.md
  publicKey = {
    "E222AA02" = fetchurl {
      url = "https://github.com/bisq-network/bisq/releases/download/v${version}/E222AA02.asc";
      hash = sources."key-E222AA02-hash";
    };

    "4A133008" = fetchurl {
      url = "https://github.com/bisq-network/bisq/releases/download/v${version}/4A133008.asc";
      hash = sources."key-4A133008-hash";
    };

    "387C8307" = fetchurl {
      url = "https://github.com/bisq-network/bisq/releases/download/v${version}/387C8307.asc";
      hash = sources."key-387C8307-hash";
    };
  };

  # The Tor which Bisq runs comes with the .deb; the system's tor is unused.
  # The Tor library starts Tor in a session of its own with setsid, which it
  # looks up in PATH and which util-linux provides.
  binPath = lib.makeBinPath [
    coreutils
    util-linux
  ];

  # The Tor bundle brings its own libevent and OpenSSL, but expects glibc and
  # zlib from the system (bisq/docs/specifications/network/tor-startup.md).
  # Bisq runs Tor in the sandy sandbox, which grants Tor's ELF interpreter from
  # the store but no other store path, so these copies go into the bundle.
  torBundleLibs = [
    "libc.so.6"
    "libm.so.6"
    "libdl.so.2"
    "libpthread.so.0"
    # The pluggable transports use it for name resolution.
    "libresolv.so.2"
  ];

  libraryPath = lib.makeLibraryPath [
    gtk3
    glib
    cairo
    pango
    atk
    gdk-pixbuf
    harfbuzz
    freetype
    fontconfig
    libGL
    libglvnd
    libx11
    libxtst
    libxxf86vm
    stdenv.cc.cc
  ];
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;

  pname = "bisq1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/bisq-network/bisq/releases/download/v${version}/Bisq-64bit-${version}.deb";
    hash = sources."deb-hash";

    # Verify the upstream Debian package's detached PGP signature prior to use.
    # This ensures that a successful build of this Nix package requires the
    # signed Debian package to pass verification, preserving Bisq's trust model.
    nativeBuildInputs = [ gnupg ];
    downloadToTemp = true;

    postFetch = ''
      pushd $(mktemp -d)
      export GNUPGHOME=./gnupg
      mkdir -m 700 -p $GNUPGHOME
      ln -s $downloadedFile ./Bisq-64bit-${version}.deb
      ln -s ${finalAttrs.signature} ./signature.asc
      gpg --import ${publicKey."E222AA02"}
      gpg --import ${publicKey."4A133008"}
      gpg --import ${publicKey."387C8307"}
      gpg --batch --verify signature.asc Bisq-64bit-${version}.deb
      popd
      mv $downloadedFile $out
    '';
  };

  signature = fetchurl {
    url = "https://github.com/bisq-network/bisq/releases/download/v${version}/Bisq-64bit-${version}.deb.asc";
    hash = sources."sig-hash";
  };

  nativeBuildInputs = [
    copyDesktopItems
    dpkg
    imagemagick
    makeBinaryWrapper
    patchelf
    unzip
    zip
    gnupg
  ];

  # Host dependencies of which the build ships copies inside the Tor bundle;
  # see buildPhase.
  buildInputs = [
    glibc
    zlib
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "bisq";
      exec = "bisq";
      icon = "bisq";
      desktopName = "Bisq";
      genericName = "Decentralized bitcoin exchange";
      categories = [
        "Network"
        "P2P"
      ];
    })

    (makeDesktopItem {
      name = "bisq-hidpi";
      exec = "bisq-hidpi";
      icon = "bisq";
      desktopName = "Bisq (HiDPI)";
      genericName = "Decentralized bitcoin exchange";
      categories = [
        "Network"
        "P2P"
      ];
    })
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg -x $src .
    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild

    # The Tor expert bundle inside the jar of the Tor library is built for a
    # distribution which has glibc in /lib64 and zlib in the system: its
    # programs name /lib64/ld-linux-x86-64.so.2 as their interpreter, and tor
    # links against libz.so.1. Bisq runs them in a sandy sandbox which lets
    # them read nothing but their own directory, their data directory and
    # their ELF interpreter, so the interpreter has to point into the store
    # and the libraries have to sit next to the programs, where tor's
    # LD_LIBRARY_PATH finds them.
    ldso=${glibc}/lib/ld-linux-x86-64.so.2

    # The jar is named after the version of the Tor library, which releases
    # bump without a change of the bundle layout. Patch every jar which
    # carries the resource; the classpath order of lib/app/* is unspecified.
    for jar in opt/bisq/lib/app/tor-[0-9]*.jar; do
      unzip -qo "$jar" tor.zip
      rm -rf tor-bundle
      mkdir tor-bundle
      unzip -q tor.zip -d tor-bundle
      rm tor.zip

      pushd tor-bundle
      # Every dynamically-linked program of the bundle: the set grows with
      # the pluggable transports which upstream adds. Libraries carry an
      # interpreter of their own (glibc's libc does), but a loader never
      # execs it, and unpatched copies stay identical to the store.
      elfs=$(find . -type f -not -name '*.so*' | while read -r f; do
        if readelf -l "$f" 2>/dev/null | grep INTERP > /dev/null; then
          echo "$f"
        fi
      done)
      for f in $elfs; do
        patchelf --set-interpreter "$ldso" "$f"
      done
      for lib in ${lib.escapeShellArgs torBundleLibs}; do
        cp -L "${glibc}/lib/$lib" .
      done
      cp -L ${zlib}/lib/libz.so.1 .

      # The sandbox leaves the bundle directory as the only library search
      # path besides the interpreter: fail the build when a program of the
      # bundle would not load there, as it does when the copies above miss a
      # library of the bundle.
      for f in $elfs; do
        trace=$(LD_LIBRARY_PATH=$PWD LD_TRACE_LOADED_OBJECTS=1 "$ldso" "$f" || true)
        if grep -q "not found" <<<"$trace"; then
          echo "Libraries of $f unresolved from the bundle directory:" >&2
          printf '%s\n' "$trace" >&2
          exit 1
        fi
      done

      # Normalise the timestamps which zip stores, so that rebuilds of the
      # package produce the same bytes.
      find . -exec touch -d @0 {} +
      find . -mindepth 1 -printf '%P\n' | LC_ALL=C sort | zip -qX ../tor.zip -@
      popd

      touch -d @0 tor.zip
      zip -q "$jar" tor.zip
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp -r opt/bisq/lib/app $out/lib

    # The libraries copied into the bundle sit in a compressed archive, so the
    # reference scanner cannot see the store paths they come from.
    mkdir -p $out/share/bisq1
    printf '%s\n' ${glibc} ${zlib} > $out/share/bisq1/bundled-tor-libs

    install -D -m 777 ${bisq-launcher ""} $out/bin/bisq
    substituteAllInPlace $out/bin/bisq
    wrapProgram $out/bin/bisq --prefix PATH : ${binPath} --prefix LD_LIBRARY_PATH : ${libraryPath}

    install -D -m 777 ${bisq-launcher "-Dglass.gtk.uiScale=2.0"} $out/bin/bisq-hidpi
    substituteAllInPlace $out/bin/bisq-hidpi
    wrapProgram $out/bin/bisq-hidpi --prefix PATH : ${binPath} --prefix LD_LIBRARY_PATH : ${libraryPath}

    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      # exclude-chunk keeps the build time out of the icons.
      magick opt/bisq/lib/Bisq.png -define png:exclude-chunk=date,time -resize $size bisq.png
      install -Dm644 -t $out/share/icons/hicolor/$size/apps bisq.png
    done

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Decentralized bitcoin exchange network (Bisq 1)";
    homepage = "https://bisq.network";
    mainProgram = "bisq";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ pmw ];
    platforms = [
      "x86_64-linux"
    ];
  };
})
