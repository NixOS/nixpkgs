{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gfortran,
  blas,
  lapack,
}:

assert !blas.isILP64;
assert !lapack.isILP64;

stdenv.mkDerivation (finalAttrs: {
  pname = "harminv";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "NanoComp";
    repo = "harminv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a2xf1CUyWUsCE+xUZfJJaKKktn2XznFnJQRE0AxVuuY=";
  };

  # File is missing in the git checkout but required by autotools
  postPatch = ''
    touch ChangeLog
  '';

  nativeBuildInputs = [
    autoreconfHook
    gfortran
  ];

  buildInputs = [
    blas
    lapack
  ];

  configureFlags = [
    "--enable-shared"
    "--enable-maintainer-mode"
  ];

  meta = {
    description = "Harmonic inversion algorithm of Mandelshtam: decompose signal into sum of decaying sinusoids";
    homepage = "https://github.com/NanoComp/harminv";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [
      sheepforce
      markuskowa
    ];
    platforms = lib.platforms.linux;
  };
})
