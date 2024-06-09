{ stdenvNoCC, lib, makeWrapper, fetchurl, makeDesktopItem, copyDesktopItems
, imagemagick, openjdk, dpkg, writeScript, bash, tor, zip, gnupg }:

let
  bisq-launcher = args:
    writeScript "bisq-launcher" ''
      #! ${bash}/bin/bash

      # This is just a comment to convince Nix that Tor is a
      # runtime dependency; The Tor binary is in a *.jar file,
      # whereas Nix only scans for hashes in uncompressed text.
      # ${bisq-tor}

      rm -fR $HOME/.local/share/Bisq2/tor

      exec "${openjdk}/bin/java" -Djpackage.app-version=@version@ -classpath @out@/lib/app/desktop-app-launcher.jar:@out@/lib/app/* ${args} bisq.desktop_app_launcher.DesktopAppLauncher "$@"
    '';

  bisq-tor = writeScript "bisq-tor" ''
    #! ${bash}/bin/bash

    exec ${tor}/bin/tor "$@"
  '';

  # Alejandro Garcia's public key was obtained from
  # https://bisq.network/pubkey/E222AA02.asc
  publicKey = ./pubkey.asc;
in stdenvNoCC.mkDerivation rec {
  pname = "bisq2";
  version = "2.1.0";

  src = fetchurl {
    url =
      "https://github.com/bisq-network/bisq2/releases/download/v${version}/Bisq-${version}.deb";
    sha256 = "sha256-nvJy7V0Jh0gWpDtj9tq4yjd/npOcy+wTo8YKAOJUOJs=";

    # Verify the upstream Debian package prior to extraction.
    # See https://bisq.wiki/Downloading_and_installing#Verify_installer_file
    # This ensures that a successful build of this Nix package requires the Debian
    # package to pass verification.
    nativeBuildInputs = [ gnupg ];
    downloadToTemp = true;

    postFetch = ''
      pushd $(mktemp -d)
      export GNUPGHOME=./gnupg
      mkdir -m 700 -p $GNUPGHOME
      ln -s $downloadedFile ./Bisq-${version}.deb
      ln -s ${signature} ./signature.asc
      gpg --import ${publicKey}
      gpg --batch --verify signature.asc Bisq-${version}.deb
      popd
      mv $downloadedFile $out
    '';
  };

  signature = fetchurl {
    url =
      "https://github.com/bisq-network/bisq2/releases/download/v${version}/Bisq-${version}.deb.asc";
    sha256 = "sha256-D8hLTTXTnoC75sePBZu2SO4I6DldwWNaxJCSDH+OElE=";
  };

  nativeBuildInputs =
    [ copyDesktopItems dpkg imagemagick makeWrapper zip gnupg ];

  desktopItems = [
    (makeDesktopItem {
      name = "Bisq2";
      exec = "bisq2";
      icon = "bisq2";
      desktopName = "Bisq ${version}";
      genericName = "Decentralized bitcoin exchange";
      categories = [ "Network" "P2P" ];
    })

    (makeDesktopItem {
      name = "Bisq2-hidpi";
      exec = "bisq2-hidpi";
      icon = "bisq2";
      desktopName = "Bisq ${version} (HiDPI)";
      genericName = "Decentralized bitcoin exchange";
      categories = [ "Network" "P2P" ];
    })
  ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  buildPhase = ''
    # Replace the Tor binary embedded in tor.jar (which is in the zip archive tor.zip)
    # with the Tor binary from Nixpkgs.

    cp ${bisq-tor} ./tor
    zip tor.zip ./tor
    zip opt/bisq2/lib/app/tor.jar tor.zip
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp -r opt/bisq2/lib/app $out/lib

    install -D -m 777 ${bisq-launcher ""} $out/bin/bisq2
    substituteAllInPlace $out/bin/bisq2

    install -D -m 777 ${
      bisq-launcher "-Dglass.gtk.uiScale=2.0"
    } $out/bin/bisq2-hidpi
    substituteAllInPlace $out/bin/bisq2-hidpi

    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      magick convert opt/bisq2/lib/Bisq2.png -resize $size bisq2.png
      install -Dm644 -t $out/share/icons/hicolor/$size/apps bisq2.png
    done;

    runHook postInstall
  '';

  meta = with lib; {
    description = "A decentralized bitcoin exchange network";
    homepage = "https://bisq.network";
    mainProgram = "bisq2";
    sourceProvenance = with sourceTypes; [ binaryBytecode nativeBinaryCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ emmanuelrosa ];
    platforms = [ "x86_64-linux" ];
  };
}
