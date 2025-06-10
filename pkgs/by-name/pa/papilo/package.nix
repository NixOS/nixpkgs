{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  blas,
  boost,
  gfortran12,
  tbb,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "papilo";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "papilo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/1AsAesUh/5YXeCU2OYopoG3SXAwAecPD88QvGkb2bY=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    blas
    boost
    cmake
    gfortran12
    zlib
  ];

  propagatedBuildInputs = [ tbb ];

  strictDeps = true;

  cmakeFlags = [ "-DTBB=off" ];

  doCheck = true;

  meta = {
    homepage = "https://scipopt.org/";
    description = "Parallel Presolve for Integer and Linear Optimization";
    license = with lib.licenses; [ lgpl3Plus ];
    mainProgram = "papilo";
    maintainers = with lib.maintainers; [ david-r-cox ];
    platforms = lib.platforms.unix;
  };
})
