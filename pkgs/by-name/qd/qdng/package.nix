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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "quantum-dynamics-ng";
    repo = "QDng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SK1sutYXlhgZffl/bJb/iRTGOVNYcnnfsSQPbiS3b50=";
  };

  outputs = [
    "out"
    "dev"
  ];

  configureFlags = [
    "--enable-openmp"
    "--disable-gccopt"
  ];

  enableParallelBuilding = true;

  # Remove static library leftovers
  postInstall = ''
    rm -r $out/lib
  '';

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
