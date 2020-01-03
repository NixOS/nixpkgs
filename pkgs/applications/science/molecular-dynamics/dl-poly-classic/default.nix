{ stdenv, fetchurl
, gfortran, mpi
}:

stdenv.mkDerivation {
  version = "1.10";
  pname = "DL_POLY_Classic";

  src = fetchurl {
    url = "https://ccpforge.cse.rl.ac.uk/gf/download/frsrelease/574/8924/dl_class_1.10.tar.gz";
    sha256 = "1r76zvln3bwycxlmqday0sqzv5j260y7mdh66as2aqny6jzd5ld7";
  };

  buildInputs = [ mpi gfortran ];

  configurePhase = ''
    cd source
    cp -v ../build/MakePAR Makefile
  '';

  buildPhase = ''
    make dlpoly
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -v ../execute/DLPOLY.X $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://www.ccp5.ac.uk/DL_POLY_C;
    description = "DL_POLY Classic is a general purpose molecular dynamics simulation package";
    license = licenses.bsdOriginal;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.costrouc ];
  };
}
