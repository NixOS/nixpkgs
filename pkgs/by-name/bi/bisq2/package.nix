{
  stdenvNoCC,
  lib,
  makeWrapper,
  runtimeShell,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  jdk23,
  dpkg,
  writeShellScript,
  bash,
  tor,
  zip,
  gnupg,
}:

let
  version = "2.1.2";

  jdk = jdk23.override { enableJavaFX = true; };

  bisq-launcher =
    args:
    writeShellScript "bisq-launcher" ''
      # This is just a comment to convince Nix that Tor is a
      # runtime dependency; The Tor binary is in a *.jar file,
      # whereas Nix only scans for hashes in uncompressed text.
      # ${lib.getExe' tor "tor"}

      rm -fR $HOME/.local/share/Bisq2/tor

      exec "${lib.getExe jdk}" -Djpackage.app-version=@version@ -classpath @out@/lib/app/desktop-app-launcher.jar:@out@/lib/app/* ${args} bisq.desktop_app_launcher.DesktopAppLauncher "$@"
    '';

  # A given release will be signed by either Alejandro Garcia or Henrik Jannsen
  # as indicated in the file
  # https://github.com/bisq-network/bisq2/releases/download/v${version}/signingkey.asc
  publicKey =
    {
      "E222AA02" = fetchurl {
        url = "https://github.com/bisq-network/bisq2/releases/download/v${version}/E222AA02.asc";
        sha256 = "sha256-31uBpe/+0QQwFyAsoCt1TUWRm0PHfCFOGOx1M16efoE=";
      };

      "387C8307" = fetchurl {
        url = "https://github.com/bisq-network/bisq2/releases/download/v${version}/387C8307.asc";
        sha256 = "sha256-PrRYZLT0xv82dUscOBgQGKNf6zwzWUDhriAffZbNpmI=";
      };
    }
    ."387C8307";
in
stdenvNoCC.mkDerivation rec {
  inherit version;

  pname = "bisq2";

  src = fetchurl {
    url = "https://github.com/bisq-network/bisq2/releases/download/v${version}/Bisq-${version}.deb";
    sha256 = "0zgv70xlz3c9mrwmiaa1dgagbc441ppk2vrkgard8zjrvk8rg7va";

    # Verify the upstream Debian package prior to extraction.
    # See https://bisq.wiki/Bisq_2#Installation
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
    url = "https://github.com/bisq-network/bisq2/releases/download/v${version}/Bisq-${version}.deb.asc";
    sha256 = "sha256-WZhI8RDmb7nQqpCQJM86vrp8qQNg+mvRVdSPcDqgzxE=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    dpkg
    imagemagick
    makeWrapper
    zip
    gnupg
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "bisq2";
      exec = "bisq2";
      icon = "bisq2";
      desktopName = "Bisq 2";
      genericName = "Decentralized bitcoin exchange";
      categories = [
        "Network"
        "P2P"
      ];
    })

    (makeDesktopItem {
      name = "bisq2-hidpi";
      exec = "bisq2-hidpi";
      icon = "bisq2";
      desktopName = "Bisq 2 (HiDPI)";
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
    # Replace the Tor binary embedded in tor.jar (which is in the zip archive tor.zip)
    # with the Tor binary from Nixpkgs.

    makeWrapper ${lib.getExe' tor "tor"} ./tor
    zip tor.zip ./tor
    zip opt/bisq2/lib/app/tor.jar tor.zip
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp -r opt/bisq2/lib/app $out/lib

    install -D -m 777 ${bisq-launcher ""} $out/bin/bisq2
    substituteAllInPlace $out/bin/bisq2

    install -D -m 777 ${bisq-launcher "-Dglass.gtk.uiScale=2.0"} $out/bin/bisq2-hidpi
    substituteAllInPlace $out/bin/bisq2-hidpi

    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      magick convert opt/bisq2/lib/Bisq2.png -resize $size bisq2.png
      install -Dm644 -t $out/share/icons/hicolor/$size/apps bisq2.png
    done;

    runHook postInstall
  '';

  meta = with lib; {
    description = "Decentralized bitcoin exchange network";
    homepage = "https://bisq.network";
    mainProgram = "bisq2";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
    ];
    license = licenses.mit;
    maintainers = with maintainers; [ emmanuelrosa ];
    platforms = [ "x86_64-linux" ];
  };
}
