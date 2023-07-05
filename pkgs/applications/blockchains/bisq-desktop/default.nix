{ stdenv
, lib
, makeWrapper
, fetchurl
, makeDesktopItem
, copyDesktopItems
, imagemagick
, openjdk11
, dpkg
, writeScript
, bash
, strip-nondeterminism
, tor
, zip
, xz
}:

let
  bisq-launcher = args: writeScript "bisq-launcher" ''
    #! ${bash}/bin/bash

    # This is just a comment to convince Nix that Tor is a
    # runtime dependency; The Tor binary is in a *.jar file,
    # whereas Nix only scans for hashes in uncompressed text.
    # ${bisq-tor}

    JAVA_TOOL_OPTIONS="-XX:+UseG1GC -XX:MaxHeapFreeRatio=10 -XX:MinHeapFreeRatio=5 -XX:+UseStringDeduplication ${args}" bisq-desktop-wrapped "$@"
  '';

  bisq-tor = writeScript "bisq-tor" ''
    #! ${bash}/bin/bash

    exec ${tor}/bin/tor "$@"
  '';
in
stdenv.mkDerivation rec {
  pname = "bisq-desktop";
  version = "1.9.10";

  src = fetchurl {
    url = "https://github.com/bisq-network/bisq/releases/download/v${version}/Bisq-64bit-${version}.deb";
    sha256 = "1p6hwamc3vzhfg4dgrmh0vf8cxi9s46a14pjnjdyg9zgn4dyr1nm";
  };

  nativeBuildInputs = [
    copyDesktopItems
    dpkg
    imagemagick
    makeWrapper
    strip-nondeterminism
    xz
    zip
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Bisq";
      exec = "bisq-desktop";
      icon = "bisq";
      desktopName = "Bisq ${version}";
      genericName = "Decentralized bitcoin exchange";
      categories = [ "Network" "P2P" ];
    })

    (makeDesktopItem {
      name = "Bisq-hidpi";
      exec = "bisq-desktop-hidpi";
      icon = "bisq";
      desktopName = "Bisq ${version} (HiDPI)";
      genericName = "Decentralized bitcoin exchange";
      categories = [ "Network" "P2P" ];
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
    zip -r opt/bisq/lib/app/desktop-${version}-all.jar native
    strip-nondeterminism opt/bisq/lib/app/desktop-${version}-all.jar
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp opt/bisq/lib/app/desktop-${version}-all.jar $out/lib

    makeWrapper ${openjdk11}/bin/java $out/bin/bisq-desktop-wrapped \
      --add-flags "-jar $out/lib/desktop-${version}-all.jar bisq.desktop.app.BisqAppMain"

    makeWrapper ${bisq-launcher ""} $out/bin/bisq-desktop \
      --prefix PATH : $out/bin

    makeWrapper ${bisq-launcher "-Dglass.gtk.uiScale=2.0"} $out/bin/bisq-desktop-hidpi \
      --prefix PATH : $out/bin

    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      convert opt/bisq/lib/Bisq.png -resize $size bisq.png
      install -Dm644 -t $out/share/icons/hicolor/$size/apps bisq.png
    done;

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A decentralized bitcoin exchange network";
    homepage = "https://bisq.network";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers; [ juaningan emmanuelrosa ];
    platforms = [ "x86_64-linux" ];
  };
}
