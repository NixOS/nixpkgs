{
  lib,
  stdenv,
  fetchurl,
  gfortran,
  mpi,
}:

stdenv.mkDerivation {
  version = "1.10";
  pname = "DL_POLY_Classic";

  src = fetchurl {
    url = "https://ccpforge.cse.rl.ac.uk/gf/download/frsrelease/574/8924/dl_class_1.10.tar.gz";
    sha256 = "1r76zvln3bwycxlmqday0sqzv5j260y7mdh66as2aqny6jzd5ld7";
  };

  nativeBuildInputs = [ gfortran ];

  buildInputs = [ mpi ];

  configurePhase = ''
    cd source
    cp -v ../build/MakePAR Makefile
  '';

  # https://gitlab.com/DL_POLY_Classic/dl_poly/-/blob/master/README
  env.NIX_CFLAGS_COMPILE = "-fallow-argument-mismatch";

  buildPhase = ''
    make dlpoly
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -v ../execute/DLPOLY.X $out/bin
  '';

  meta = with lib; {
    homepage = "https://www.ccp5.ac.uk/DL_POLY_C";
    description = "DL_POLY Classic is a general purpose molecular dynamics simulation package";
    mainProgram = "DLPOLY.X";
    license = licenses.bsdOriginal;
    platforms = platforms.unix;
    maintainers = [ maintainers.costrouc ];
  };
}
