{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  blas,
  gfortran,
  openssh,
  mpi,
}:

stdenv.mkDerivation rec {
  pname = "globalarrays";
  version = "5.9.2";

  src = fetchFromGitHub {
    owner = "GlobalArrays";
    repo = "ga";
    rev = "v${version}";
    sha256 = "sha256-leCvbWteOp7z7ORwtljA+KslHUptY2vdupZTmAjsArg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gfortran
  ];
  buildInputs = [
    mpi
    blas
    openssh
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  preConfigure = ''
    configureFlagsArray+=( "--enable-i8" \
                           "--with-mpi" \
                           "--with-mpi3" \
                           "--enable-eispack" \
                           "--enable-underscoring" \
                           "--with-blas8=${blas}/lib -lblas" )
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Global Arrays Programming Models";
    homepage = "http://hpc.pnl.gov/globalarrays/";
    maintainers = [ maintainers.markuskowa ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
