{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  gfortran,
  pkg-config,
  blas,
  lapack,
  fftw,
  hdf5,
  libctl,
  guile,
  perl,
}:

assert !blas.isILP64;
assert !lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "mpb";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "NanoComp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+2cMjZSGdfngtGoAeZRPRPBDvflTEIOWO8Se0W6jv9k=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gfortran
    pkg-config
  ];

  buildInputs = [
    blas
    lapack
    fftw
    hdf5
    libctl
    guile
    perl
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-libctl=yes"
    "--with-libctl=${libctl}"
    "--enable-maintainer-mode"
    "--disable-dependency-tracking"
  ] ++ lib.optional (!stdenv.hostPlatform.isStatic) "--enable-shared";

  doCheck = true;

  meta = {
    description = "MIT Photonic-Bands: computation of photonic band structures in periodic media";
    homepage = "https://mpb.readthedocs.io/en/latest/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      sheepforce
    ];
  };
}
