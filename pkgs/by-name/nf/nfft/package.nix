{
  autoconf,
  automake,
  cunit,
  fetchFromGitHub,
  fftw,
  lib,
  libtool,
  llvmPackages,
  stdenv,
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

  nativeBuildInputs = [
    autoconf
    automake
    cunit
    libtool
  ];

  preConfigure = ''
    bash bootstrap.sh
  '';

  configureFlags = [
    "--enable-all"
    "--enable-openmp"
    "--enable-portable-binary"
  ];

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
