{
  autoconf,
  automake,
  cunit,
  fetchFromGitHub,
  fetchpatch,
  fftw,
  lib,
  libtool,
  llvmPackages,
  stdenv,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nfft";
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "NFFT";
    repo = "nfft";
    rev = finalAttrs.version;
    hash = "sha256-HR8ME9PVC+RAv1GIgV2vK6eLU8Wk28+rSzbutThBv3w=";
  };

  patches = [
    (fetchpatch {
      name = "fix-gcc15.patch";
      url = "https://github.com/NFFT/nfft/commit/b06d01be964be7490aed797468f9722e2de1dbfa.patch";
      hash = "sha256-Ynhsyzf8ECVw4eBq50okd0oikiIfOCqFRHivuceg0KU=";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    cunit
    libtool
    bash
  ];

  preConfigure = ''
    bash bootstrap.sh
  '';

  configureFlags = [
    "--enable-all"
    "--enable-openmp"
    "--enable-portable-binary"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  enableParalleBuilding = true;

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  propagatedBuildInputs = [ fftw ];

  doCheck = true;

  meta = {
    description = "Nonequispaced fast Fourier transform";
    homepage = "https://www-user.tu-chemnitz.de/~potts/nfft/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ hmenke ];
  };
})
