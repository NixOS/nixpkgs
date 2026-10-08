{
  lib,
  stdenv,
  fetchurl,
  gfortran,
  arpack,
  spooles,
  blas,
  lapack,
}:

assert (blas.isILP64 == lapack.isILP64 && blas.isILP64 == arpack.isILP64 && !blas.isILP64);

stdenv.mkDerivation (finalAttrs: {
  pname = "calculix-ccx";
  version = "2.23";

  src = fetchurl {
    url = "https://www.dhondt.de/ccx_${finalAttrs.version}.src.tar.bz2";
    hash = "sha256-nIg4XBD7BPXcbE6YAnpRvr3YruOSDgUZDWwd0INX1uc=";
  };

  nativeBuildInputs = [ gfortran ];

  buildInputs = [
    arpack
    spooles
    blas
    lapack
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${spooles}/include/spooles"
    "-std=legacy"
    "-Wno-return-mismatch"
  ];

  patches = [
    ./calculix-ccx.patch
  ];

  postPatch = ''
    cd ccx*/src
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0755 ccx_${finalAttrs.version} $out/bin/ccx

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.calculix.de";
    description = "Three-dimensional structural finite element program";
    mainProgram = "ccx";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magicquark ];
    platforms = lib.platforms.unix;
  };
})
