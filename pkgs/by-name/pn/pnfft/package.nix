{
  autoreconfHook,
  fetchFromGitHub,
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
  version = "1.0.7-alpha-unstable-2018-06-04";

  src = fetchFromGitHub {
    owner = "mpip";
    repo = "pnfft";
    rev = "a0bb24b8fa8af59c9e599b1cc3914586636d9125";
    hash = "sha256-Cgusm/zWCLy//3qh/YAXjCZGl+QOnycUjUCQsd1HxvQ=";
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
  ]
  ++ lib.optional (precision != "double") "--enable-${precision}";

  buildInputs = [ gsl ] ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  propagatedBuildInputs = [ pfft' ];

  enableParallelBuilding = true;

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
