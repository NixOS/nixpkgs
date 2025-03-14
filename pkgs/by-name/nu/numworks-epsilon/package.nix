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

  nativeBuildInputs = [ pkg-config ];
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

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simulator for Epsilon, a High-performance graphing calculator operating system";
    homepage = "https://numworks.com/";
    license = licenses.cc-by-nc-sa-40;
    maintainers = with maintainers; [ erikbackman ];
    platforms = [ "x86_64-linux" ];
  };
}
