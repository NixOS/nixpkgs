{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flex,
  gfortran,
  blas,
  bzip2,
  fftw,
  lapack,
  libxml2,
  protobuf_21,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qdng";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "quantum-dynamics-ng";
    repo = "QDng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T59Bb014KSUOOFTFjPOrWmbF6GqIqAIyrb3Xe5TwU88=";
  };

  configureFlags = [
    "--enable-openmp"
    "--disable-gccopt"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    gfortran
  ];

  buildInputs = [
    blas
    bzip2
    fftw
    lapack
    libxml2
    protobuf_21
    zlib
  ];

  meta = {
    description = "Molecular wavepacket dynamics package";
    homepage = "https://github.com/quantum-dynamics-ng/QDng";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.markuskowa ];
    license = lib.licenses.gpl3Only;
  };
})
