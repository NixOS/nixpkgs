{
  lib,
  stdenv,
  fetchFromGitHub,
  useCoefficients ? false,
  indicateProgress ? false,
  useGoogleHashmap ? false,
  sparsehash ? null,
  fileFormat ? "lowerTriangularCsv",
}:

assert lib.assertOneOf "fileFormat" fileFormat [
  "lowerTriangularCsv"
  "upperTriangularCsv"
  "dipha"
];
assert useGoogleHashmap -> sparsehash != null;

let
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

  buildInputs = lib.optional useGoogleHashmap sparsehash;

  buildFlags =
    [
      "-std=c++11"
      "-O3"
      "-D NDEBUG"
    ]
    ++ lib.optional useCoefficients "-D USE_COEFFICIENTS"
    ++ lib.optional indicateProgress "-D INDICATE_PROGRESS"
    ++ lib.optional useGoogleHashmap "-D USE_GOOGLE_HASHMAP"
    ++ lib.optional (fileFormat == "lowerTriangularCsv") "-D FILE_FORMAT_LOWER_TRIANGULAR_CSV"
    ++ lib.optional (fileFormat == "upperTriangularCsv") "-D FILE_FORMAT_UPPER_TRIANGULAR_CSV"
    ++ lib.optional (fileFormat == "dipha") "-D FILE_FORMAT_DIPHA";

  buildPhase = "c++ ripser.cpp -o ripser $buildFlags";

  installPhase = ''
    mkdir -p $out/bin
    cp ripser $out/bin
  '';

  meta = {
    description = "Lean C++ code for the computation of Vietoris–Rips persistence barcodes";
    mainProgram = "ripser";
    homepage = "https://github.com/Ripser/ripser";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ erikryb ];
    platforms = lib.platforms.linux;
  };
}
