{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libpng
, libtiff
, libjpeg
, SDL2
, gdal
, octave
, rustPlatform
, cargo
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vpv";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "kidanger";
    repo = "vpv";
    rev = "v${finalAttrs.version}";
    sha256 = "0cphgq1pqmwrjdmq524j5y522iaq6yhp2dpjdv0a3f9558dayxix";
  };

  cargoRoot = "src/fuzzy-finder";
  cargoDeps = rustPlatform.fetchCargoTarball {
    src = finalAttrs.src;
    sourceRoot = "source/src/fuzzy-finder";
    hash = "sha256-CDKlmwA2Wj78xPaSiYPmIJ7xmiE5Co+oGGejZU3v1zI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
  ];

  buildInputs = [
    libpng
    libtiff
    libjpeg
    SDL2
    gdal
    octave
  ];

  cmakeFlags = [
    "-DUSE_GDAL=ON"
    "-DUSE_OCTAVE=ON"
    "-DVPV_VERSION=v${finalAttrs.version}"
    "-DBUILD_TESTING=ON"
  ];

  meta = {
    homepage = "https://github.com/kidanger/vpv";
    description = "Image viewer for image processing experts";
    maintainers = [ lib.maintainers.kidanger ];
    license = lib.licenses.gpl3;
    broken = stdenv.isDarwin; # the CMake expects the SDL2::SDL2main target for darwin
  };
})
