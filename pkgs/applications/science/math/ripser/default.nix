{ lib, stdenv, fetchFromGitHub
, useCoefficients ? false
, indicateProgress ? false
, useGoogleHashmap ? false, sparsehash ? null
, fileFormat ? "lowerTriangularCsv"
}:

with lib;

assert assertOneOf "fileFormat" fileFormat
  ["lowerTriangularCsv" "upperTriangularCsv" "dipha"];
assert useGoogleHashmap -> sparsehash != null;

let
  inherit (lib) optional;
  version = "1.2.1";
in
stdenv.mkDerivation {
  pname = "ripser";
  inherit version;

  src = fetchFromGitHub {
    owner = "Ripser";
    repo = "ripser";
    rev = "v${version}";
    sha256 = "sha256-BxmkPQ/nl5cF+xwQMTjXnLgkLgdmT/39y7Kzl2wDfpE=";
  };

  buildInputs = optional useGoogleHashmap sparsehash;

  buildFlags = [
    "-std=c++11"
    "-O3"
    "-D NDEBUG"
  ]
  ++ optional useCoefficients "-D USE_COEFFICIENTS"
  ++ optional indicateProgress "-D INDICATE_PROGRESS"
  ++ optional useGoogleHashmap "-D USE_GOOGLE_HASHMAP"
  ++ optional (fileFormat == "lowerTriangularCsv") "-D FILE_FORMAT_LOWER_TRIANGULAR_CSV"
  ++ optional (fileFormat == "upperTriangularCsv") "-D FILE_FORMAT_UPPER_TRIANGULAR_CSV"
  ++ optional (fileFormat == "dipha") "-D FILE_FORMAT_DIPHA"
  ;

  buildPhase = "c++ ripser.cpp -o ripser $buildFlags";

  installPhase = ''
    mkdir -p $out/bin
    cp ripser $out/bin
  '';

  meta = {
    description = "A lean C++ code for the computation of Vietoris–Rips persistence barcodes";
    homepage = "https://github.com/Ripser/ripser";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [erikryb];
    platforms = lib.platforms.linux;
  };
}
