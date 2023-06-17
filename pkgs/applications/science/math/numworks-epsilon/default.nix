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
}:

stdenv.mkDerivation rec {
  pname = "numworks-epsilon";
  version = "15.5.0";

  src = fetchFromGitHub {
    owner = "numworks";
    repo = "epsilon";
    rev = version;
    sha256 = "fPBO3FzZ4k5OxG+Ifc6R/au4Te974HNKAEdHz+aFdSg=";
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
  ];

  makeFlags = [
    "PLATFORM=simulator"
  ];

  patches = [
    # Remove make rule Introduced in cba596dde7
    # which causes it to not build with nix
    ./0001-ion-linux-makerules.patch
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
