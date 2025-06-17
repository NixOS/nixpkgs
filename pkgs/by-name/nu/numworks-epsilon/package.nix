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

    mkdir -p $out/bin
    cp ./output/release/simulator/linux/epsilon.bin $out/bin/epsilon

    # Build the logo
    assets="$src/ion/src/simulator/assets"
    logo_dir="$out/share/icons/hicolor/scalable/apps"
    logo="$logo_dir/numworks.svg"
    mkdir -p "$logo_dir"

    # Take opening svg tag
    grep '<svg' "$assets/logo.svg" > "$logo"

    # Insert path from logo mask and change color
    grep path "$assets/icon_mask.svg" | sed 's/fill="[^"]*"/fill="#edb14b"/' >> "$logo"

    # Add remainder of logo
    grep -v '<svg' "$assets/logo.svg" >> "$logo"

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
