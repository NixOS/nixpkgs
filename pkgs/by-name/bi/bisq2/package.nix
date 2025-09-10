{
  stdenv,
  lib,
  makeBinaryWrapper,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  jdk23,
  dpkg,
  writeShellScript,
  tor,
  zip,
  gnupg,
  coreutils,

  # Used by the bundled webcam-app
  libv4l,

  # Used by the testing package bisq2-webcam-app
  callPackage,
  socat,
  unzip,
}:

let
  version = "2.1.7";

  jdk = jdk23.override { enableJavaFX = true; };

  bisq-launcher =
    args:
    writeShellScript "bisq-launcher" ''
      rm -fR $HOME/.local/share/Bisq2/tor

      exec "${lib.getExe jdk}" -Djpackage.app-version=@version@ -classpath @out@/lib/app/desktop-app-launcher.jar:@out@/lib/app/* ${args} bisq.desktop_app_launcher.DesktopAppLauncher "$@"
    '';

  # A given release will be signed by either Alejandro Garcia or Henrik Jannsen
  # as indicated in the file
  # https://github.com/bisq-network/bisq2/releases/download/v${version}/signingkey.asc
  publicKey = {
    "E222AA02" = fetchurl {
      url = "https://github.com/bisq-network/bisq2/releases/download/v${version}/E222AA02.asc";
      hash = "sha256-31uBpe/+0QQwFyAsoCt1TUWRm0PHfCFOGOx1M16efoE=";
    };

    "387C8307" = fetchurl {
      url = "https://github.com/bisq-network/bisq2/releases/download/v${version}/387C8307.asc";
      hash = "sha256-PrRYZLT0xv82dUscOBgQGKNf6zwzWUDhriAffZbNpmI=";
    };
  };

  binPath = lib.makeBinPath [
    coreutils
    tor
  ];

  libraryPath = lib.makeLibraryPath [
    stdenv.cc.cc
    libv4l
  ];
in
stdenv.mkDerivation (finalAttrs: rec {
  inherit version;

  pname = "bisq2";

  # nixpkgs-update: no auto update
  src = fetchurl {
    url = "https://github.com/bisq-network/bisq2/releases/download/v${version}/Bisq-${version}.deb";
    hash = "sha256-kNQbTZoHFR2qFw/Jjc9iaEews/oUOYoJanmbVH/vs44=";

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
      gpg --import ${publicKey."E222AA02"}
      gpg --import ${publicKey."387C8307"}
      gpg --batch --verify signature.asc Bisq-${version}.deb
      popd
      mv $downloadedFile $out
    '';
  };

  signature = fetchurl {
    url = "https://github.com/bisq-network/bisq2/releases/download/v${version}/Bisq-${version}.deb.asc";
    hash = "sha256-Cl9EIp+ycD8Tp/bx5dXQK206jZzrYJkI/U9ItfXDRWw=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    dpkg
    imagemagick
    makeBinaryWrapper
    zip
    gnupg
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
    wrapProgram $out/bin/bisq2 --prefix PATH : ${binPath} --prefix LD_LIBRARY_PATH : ${libraryPath}

    install -D -m 777 ${bisq-launcher "-Dglass.gtk.uiScale=2.0"} $out/bin/bisq2-hidpi
    substituteAllInPlace $out/bin/bisq2-hidpi
    wrapProgram $out/bin/bisq2-hidpi --prefix PATH : ${binPath} --prefix LD_LIBRARY_PATH : ${libraryPath}

    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      magick convert opt/bisq2/lib/Bisq2.png -resize $size bisq2.png
      install -Dm644 -t $out/share/icons/hicolor/$size/apps bisq2.png
    done;

    runHook postInstall
  '';

  # The bisq2.webcam-app package is for maintainers to test scanning QR codes.
  passthru.webcam-app = callPackage ./webcam-app.nix {
    inherit
      jdk
      libraryPath
      ;
    bisq2 = finalAttrs.finalPackage.out;
  };

  meta = {
    description = "Decentralized bitcoin exchange network";
    homepage = "https://bisq.network";
    mainProgram = "bisq2";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
    ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emmanuelrosa ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
