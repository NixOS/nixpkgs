{
  stdenv,
  lib,
  fetchFromGitHub,
  libpng,
  libjpeg,
  freetype,
  xorg,
  python3,
  imagemagick,
  gcc-arm-embedded,
  pkg-config,
  python3Packages,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation rec {
  pname = "numworks-epsilon";
  version = "23.2.3";

  src = fetchFromGitHub {
    owner = "numworks";
    repo = "epsilon";
    rev = version;
    hash = "sha256-w9ddcULE1MrGnYcXA0qOg1elQv/eBhcXqhMSjWT3Bkk=";
  };

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    libpng
    libjpeg
    freetype
    xorg.libXext
    python3
    imagemagick
    gcc-arm-embedded
    python3Packages.lz4
  ];

  makeFlags = [
    "PLATFORM=simulator"
  ];

  installPhase = ''
    runHook preInstall

    mv ./output/release/simulator/linux/{epsilon.bin,epsilon}
    mkdir -p $out/bin
    cp -r ./output/release/simulator/linux/* $out/bin/

    # To build this svg:
    # copy white path from ion/src/simulator/assets/icon_mask.svg
    # paste into ion/src/simulator/assets/logo.svg and change fill to #edb14b
    install -Dm644 ${./numworks.svg} $out/share/icons/hicolor/scalable/apps/numworks.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "epsilon";
      exec = "epsilon";
      icon = "numworks";
      desktopName = "NumWorks Epsilon Calculator";
      categories = [
        "Utility"
        "Math"
      ];
      type = "Application";
    })
  ];

  meta = with lib; {
    description = "Simulator for Epsilon, a High-performance graphing calculator operating system";
    homepage = "https://numworks.com/";
    license = licenses.cc-by-nc-sa-40;
    maintainers = with maintainers; [ erikbackman ];
    platforms = [ "x86_64-linux" ];
  };
}
