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
<<<<<<< HEAD
, strip-nondeterminism
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, tor
, zip
, xz
}:

let
<<<<<<< HEAD
  bisq-launcher = args: writeScript "bisq-launcher" ''
=======
  bisq-launcher = writeScript "bisq-launcher" ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    #! ${bash}/bin/bash

    # This is just a comment to convince Nix that Tor is a
    # runtime dependency; The Tor binary is in a *.jar file,
    # whereas Nix only scans for hashes in uncompressed text.
    # ${bisq-tor}

<<<<<<< HEAD
    JAVA_TOOL_OPTIONS="-XX:+UseG1GC -XX:MaxHeapFreeRatio=10 -XX:MinHeapFreeRatio=5 -XX:+UseStringDeduplication ${args}" bisq-desktop-wrapped "$@"
=======
    JAVA_TOOL_OPTIONS="-XX:+UseG1GC -XX:MaxHeapFreeRatio=10 -XX:MinHeapFreeRatio=5 -XX:+UseStringDeduplication" bisq-desktop-wrapped "$@"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  bisq-tor = writeScript "bisq-tor" ''
    #! ${bash}/bin/bash

    exec ${tor}/bin/tor "$@"
  '';
in
stdenv.mkDerivation rec {
  pname = "bisq-desktop";
<<<<<<< HEAD
  version = "1.9.12";

  src = fetchurl {
    url = "https://github.com/bisq-network/bisq/releases/download/v${version}/Bisq-64bit-${version}.deb";
    sha256 = "0zzrl7dmd3m7pymwvl68gnjspbpzf1w17bcwr0ipgsszmr35k9rs";
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
=======
  version = "1.9.9";

  src = fetchurl {
    url = "https://github.com/bisq-network/bisq/releases/download/v${version}/Bisq-64bit-${version}.deb";
    sha256 = "0jisxzajsc4wfvxabvfzd0x9y1fxzg39fkhap1781q7wyi4ry9kd";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems imagemagick dpkg zip xz ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  desktopItems = [
    (makeDesktopItem {
      name = "Bisq";
      exec = "bisq-desktop";
      icon = "bisq";
      desktopName = "Bisq ${version}";
      genericName = "Decentralized bitcoin exchange";
      categories = [ "Network" "P2P" ];
    })
<<<<<<< HEAD

    (makeDesktopItem {
      name = "Bisq-hidpi";
      exec = "bisq-desktop-hidpi";
      icon = "bisq";
      desktopName = "Bisq ${version} (HiDPI)";
      genericName = "Decentralized bitcoin exchange";
      categories = [ "Network" "P2P" ];
    })
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  buildPhase = ''
    # Replace the embedded Tor binary (which is in a Tar archive)
    # with one from Nixpkgs.

    mkdir -p native/linux/x64/
    cp ${bisq-tor} ./tor
<<<<<<< HEAD
    tar --sort=name --mtime="@$SOURCE_DATE_EPOCH" -cJf native/linux/x64/tor.tar.xz tor
    zip -r opt/bisq/lib/app/desktop-${version}-all.jar native
    strip-nondeterminism opt/bisq/lib/app/desktop-${version}-all.jar
=======
    tar -cJf native/linux/x64/tor.tar.xz tor
    zip -r opt/bisq/lib/app/desktop-${version}-all.jar native
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp opt/bisq/lib/app/desktop-${version}-all.jar $out/lib

    makeWrapper ${openjdk11}/bin/java $out/bin/bisq-desktop-wrapped \
      --add-flags "-jar $out/lib/desktop-${version}-all.jar bisq.desktop.app.BisqAppMain"

<<<<<<< HEAD
    makeWrapper ${bisq-launcher ""} $out/bin/bisq-desktop \
      --prefix PATH : $out/bin

    makeWrapper ${bisq-launcher "-Dglass.gtk.uiScale=2.0"} $out/bin/bisq-desktop-hidpi \
=======
    makeWrapper ${bisq-launcher} $out/bin/bisq-desktop \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
