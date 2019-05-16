{ stdenv, fetchurl, fetchFromGitHub
, assembleReductionMatrix ? false
, useCoefficients ? false
, indicateProgress ? false
, useGoogleHashmap ? false, sparsehash ? null
, fileFormat ? "lowerTriangularCsv"
}:

with stdenv.lib;

assert assertOneOf "fileFormat" fileFormat
  ["lowerTriangularCsv" "upperTriangularCsv" "dipha"];
assert useGoogleHashmap -> sparsehash != null;

let
  inherit (stdenv.lib) optional;
  version = "1.0";
in
stdenv.mkDerivation {
  name = "ripser-${version}";

  src = fetchFromGitHub {
    owner = "Ripser";
    repo = "ripser";
    rev = "f69c6af6ca6883dd518c48faf41cf8901c379598";
    sha256 = "1mw2898s7l29hgajsaf75bs9bjn2sn4g2mvmh41a602jpwp9r0rz";
  };

  #Patch from dev branch to make compilation work.
  #Will be removed when it gets merged into master.
  patches = [(fetchurl {
    url = https://github.com/Ripser/ripser/commit/dc78d8ce73ee35f3828f0aad67a4e53620277ebf.patch;
    sha256 = "1y93aqpqz8fm1cxxrf90dhh67im3ndkr8dnxgbw5y96296n4r924";
  })];

  buildInputs = optional useGoogleHashmap sparsehash;

  buildFlags = [
    "-std=c++11"
    "-Ofast"
    "-D NDEBUG"
  ]
  ++ optional assembleReductionMatrix "-D ASSEMBLE_REDUCTION_MATRIX"
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
    homepage = https://github.com/Ripser/ripser;
    license = stdenv.lib.licenses.lgpl3;
    maintainers = with stdenv.lib.maintainers; [erikryb];
    platforms = stdenv.lib.platforms.linux;
  };
}
