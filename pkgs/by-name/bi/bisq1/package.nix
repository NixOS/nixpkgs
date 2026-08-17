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
  xz,
  gnupg,
  coreutils,
  tor,

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
  version = "1.10.2";

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
      hash = "sha256-Ue/UmS6F440/ybEEIAR+pdPEIksAt6QSMN6G5TZVWzc=";
    };

    "4A133008" = fetchurl {
      url = "https://github.com/bisq-network/bisq/releases/download/v${version}/4A133008.asc";
      hash = "sha256-UijG3DkJNNTakVJd2wl30mDepa27n6R/Xxfl4sjt0sk=";
    };

    "387C8307" = fetchurl {
      url = "https://github.com/bisq-network/bisq/releases/download/v${version}/387C8307.asc";
      hash = "sha256-PrRYZLT0xv82dUscOBgQGKNf6zwzWUDhriAffZbNpmI=";
    };
  };

  binPath = lib.makeBinPath [
    coreutils
    tor
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
    hash = "sha256-e7rPUhA6KF3Tz3zlYqEfM9G0owe9hAUFDifKseRvb6A=";

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
    hash = "sha256-kBRaOXuP22DvXMkJ1XQatwvTmu/Ds8FvmUgYnRT7Vg0=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    dpkg
    imagemagick
    makeBinaryWrapper
    zip
    xz
    gnupg
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

    # Replace the Tor binary bundled in tor-binary-linux64-*.jar
    # (native/linux/x64/tor.tar.xz) with the Tor binary from Nixpkgs. The
    # bundled tor is a dynamically-linked ELF expecting the
    # /lib64/ld-linux-x86-64.so.2 interpreter, which does not exist on NixOS.
    makeWrapper ${lib.getExe' tor "tor"} ./tor
    mkdir -p native/linux/x64
    tar -cf - ./tor | xz > native/linux/x64/tor.tar.xz
    zip opt/bisq/lib/app/tor-binary-linux64-*.jar native/linux/x64/tor.tar.xz >/dev/null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp -r opt/bisq/lib/app $out/lib

    install -D -m 777 ${bisq-launcher ""} $out/bin/bisq
    substituteAllInPlace $out/bin/bisq
    wrapProgram $out/bin/bisq --prefix PATH : ${binPath} --prefix LD_LIBRARY_PATH : ${libraryPath}

    install -D -m 777 ${bisq-launcher "-Dglass.gtk.uiScale=2.0"} $out/bin/bisq-hidpi
    substituteAllInPlace $out/bin/bisq-hidpi
    wrapProgram $out/bin/bisq-hidpi --prefix PATH : ${binPath} --prefix LD_LIBRARY_PATH : ${libraryPath}

    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      magick opt/bisq/lib/Bisq.png -resize $size bisq.png
      install -Dm644 -t $out/share/icons/hicolor/$size/apps bisq.png
    done

    runHook postInstall
  '';

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
