{ stdenv
, lib
, fetchFromGitHub
, libpng
, libjpeg
, freetype
, xorg
, python3
, imagemagick
, gcc-arm-embedded
, pkg-config
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "numworks-epsilon";
  version = "22.2.0";

  src = fetchFromGitHub {
    owner = "numworks";
    repo = "epsilon";
    rev = version;
    hash = "sha256-E2WaXTn8+Ky9kdZxvQmEt63Ggo6Ns0fZ0Za+rQGIMSg=";
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
