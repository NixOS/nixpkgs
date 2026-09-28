{
  autoreconfHook,
  fetchFromGitHub,
  fftwMpi,
  lib,
  llvmPackages,
  mpi,
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
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pfft-${precision}";
  version = "1.0.8-alpha";

  src = fetchFromGitHub {
    owner = "mpip";
    repo = "pfft";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T5nPlkPKjYYRCuT1tSzXNJTPs/o6zwJMv9lPCWOwabw=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  preConfigure = ''
    export FCFLAGS="-I${lib.getDev fftw'}/include"
  '';

  configureFlags = [
    "--enable-portable-binary"
  ]
  ++ lib.optional (precision != "double") "--enable-${precision}";

  buildInputs = lib.optional stdenv.cc.isClang llvmPackages.openmp;

  propagatedBuildInputs = [
    fftw'
    mpi
  ];

  doCheck = true;

  meta = {
    description = "Parallel fast Fourier transforms";
    homepage = "https://www-user.tu-chemnitz.de/~potts/workgroup/pippig/software.php.en#pfft";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hmenke ];
    platforms = lib.platforms.linux;
  };
})
