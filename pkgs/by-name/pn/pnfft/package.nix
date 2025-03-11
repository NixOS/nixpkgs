{
  autoreconfHook,
  fetchurl,
  fftwMpi,
  gsl,
  lib,
  llvmPackages,
  pfft,
  precision ? "double",
  stdenv,
}:

assert lib.elem precision [
  "single"
  "double"
  "long-double"
];

let
  fftw' = fftwMpi.override { inherit precision; };
  pfft' = pfft.override { inherit precision; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pnfft-${precision}";
  version = "1.0.7-alpha";

  src = fetchurl {
    url = "https://www-user.tu-chemnitz.de/~potts/workgroup/pippig/software/pnfft-${finalAttrs.version}.tar.gz";
    hash = "sha256-/aVY/1fuMRl1Q2O7bmc5M4aA0taGD+fcQgCdhVYr1no=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  preConfigure = ''
    export FCFLAGS="-I${lib.getDev fftw'}/include -I${lib.getDev pfft'}/include"
  '';

  configureFlags = [
    "--enable-threads"
    "--enable-portable-binary"
  ] ++ lib.optional (precision != "double") "--enable-${precision}";

  buildInputs = [ gsl ] ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  propagatedBuildInputs = [ pfft' ];

  doCheck = true;

  meta = {
    description = "Parallel nonequispaced fast Fourier transforms";
    homepage = "https://www-user.tu-chemnitz.de/~potts/workgroup/pippig/software.php.en#pnfft";
    changelog = "https://github.com/mpip/pnfft/blob/master/ChangeLog";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hmenke ];
    platforms = lib.platforms.linux;
  };
})
