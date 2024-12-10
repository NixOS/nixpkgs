{
  stdenv,
  lib,
  makeWrapper,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  openjdk11,
  dpkg,
  writeScript,
  bash,
  stripJavaArchivesHook,
  tor,
  zip,
  xz,
  findutils,
}:

let
  bisq-launcher =
    args:
    writeScript "bisq-launcher" ''
      #! ${bash}/bin/bash

      # This is just a comment to convince Nix that Tor is a
      # runtime dependency; The Tor binary is in a *.jar file,
      # whereas Nix only scans for hashes in uncompressed text.
      # ${bisq-tor}

      classpath=@out@/lib/desktop.jar:@out@/lib/*

      exec "${openjdk11}/bin/java" -Djpackage.app-version=@version@ -XX:MaxRAM=8g -Xss1280k -XX:+UseG1GC -XX:MaxHeapFreeRatio=10 -XX:MinHeapFreeRatio=5 -XX:+UseStringDeduplication -Djava.net.preferIPv4Stack=true -classpath $classpath ${args} bisq.desktop.app.BisqAppMain "$@"
    '';

  bisq-tor = writeScript "bisq-tor" ''
    #! ${bash}/bin/bash

    exec ${tor}/bin/tor "$@"
  '';
in
stdenv.mkDerivation rec {
  pname = "bisq-desktop";
  version = "1.9.17";

  src = fetchurl {
    url = "https://github.com/bisq-network/bisq/releases/download/v${version}/Bisq-64bit-${version}.deb";
    sha256 = "1wqzgxsm9p6lh0bmvw0byaxx1r5v64d024jf1pg9mykb1dnnx0wy";
  };

  nativeBuildInputs = [
    copyDesktopItems
    dpkg
    imagemagick
    makeWrapper
    stripJavaArchivesHook
    xz
    zip
    findutils
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Bisq";
      exec = "bisq-desktop";
      icon = "bisq";
      desktopName = "Bisq ${version}";
      genericName = "Decentralized bitcoin exchange";
      categories = [
        "Network"
        "P2P"
      ];
    })

    (makeDesktopItem {
      name = "Bisq-hidpi";
      exec = "bisq-desktop-hidpi";
      icon = "bisq";
      desktopName = "Bisq ${version} (HiDPI)";
      genericName = "Decentralized bitcoin exchange";
      categories = [
        "Network"
        "P2P"
      ];
    })
  ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  buildPhase = ''
    # Replace the embedded Tor binary (which is in a Tar archive)
    # with one from Nixpkgs.

    mkdir -p native/linux/x64/
    cp ${bisq-tor} ./tor
    tar --sort=name --mtime="@$SOURCE_DATE_EPOCH" -cJf native/linux/x64/tor.tar.xz tor
    tor_jar_file=$(find ./opt/bisq/lib/app -name "tor-binary-linux64-*.jar")
    zip -r $tor_jar_file native
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out $out/bin
    cp -r opt/bisq/lib/app $out/lib

    install -D -m 777 ${bisq-launcher ""} $out/bin/bisq-desktop
    substituteAllInPlace $out/bin/bisq-desktop

    install -D -m 777 ${bisq-launcher "-Dglass.gtk.uiScale=2.0"} $out/bin/bisq-desktop-hidpi
    substituteAllInPlace $out/bin/bisq-desktop-hidpi

    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      convert opt/bisq/lib/Bisq.png -resize $size bisq.png
      install -Dm644 -t $out/share/icons/hicolor/$size/apps bisq.png
    done;

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Decentralized bitcoin exchange network";
    homepage = "https://bisq.network";
    changelog = "https://github.com/bisq-network/bisq/releases/tag/v${version}";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers; [
      juaningan
      emmanuelrosa
    ];
    platforms = [ "x86_64-linux" ];
    # Requires OpenJFX 11 or 16, which are both EOL.
    broken = true;
  };
}
