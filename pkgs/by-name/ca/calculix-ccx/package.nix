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
  version = "2.22";

  src = fetchurl {
    url = "http://www.dhondt.de/ccx_${finalAttrs.version}.src.tar.bz2";
    hash = "sha256-OpTcx3WjH1cCKXNLNB1rBjAevcdZhj35Aci5vxhUwLw=";
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
    homepage = "http://www.calculix.de";
    description = "Three-dimensional structural finite element program";
    mainProgram = "ccx";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
