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
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "NanoComp";
    repo = "mpb";
    tag = "v${version}";
    hash = "sha256-naxVKD7pxefb/ht5Pa4e/T9eDzlZ0raNYPSvKNaZUn8=";
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

  # Required for build with gcc-14
  env.NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion";

  enableParallelBuilding = true;

  configureFlags = [
    "--with-libctl=yes"
    "--with-libctl=${libctl}"
    "--enable-maintainer-mode"
    "--disable-dependency-tracking"
  ]
  ++ lib.optional (!stdenv.hostPlatform.isStatic) "--enable-shared";

  doCheck = true;

  preCheck = "export OMP_NUM_THREADS=2";

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
