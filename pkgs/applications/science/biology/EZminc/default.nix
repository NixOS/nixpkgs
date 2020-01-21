{ stdenv, fetchFromGitHub, cmake, pkgconfig, libminc, bicpl, itk, fftwFloat, gsl }:

stdenv.mkDerivation rec {
  pname = "EZminc";
  name  = "${pname}-unstable-2019-07-25";

  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = pname;
    rev    = "9591edd5389a5bda2c1f606816c7cdb35c065adf";
    sha256 = "02k87qbpx0f48l2lbcjmlqx82py684z3sfi29va5icfg3hjd6j7b";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ itk libminc bicpl fftwFloat gsl ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/"
                 "-DEZMINC_BUILD_TOOLS=TRUE"
                 "-DEZMINC_BUILD_MRFSEG=TRUE"
                 "-DEZMINC_BUILD_DD=TRUE" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/BIC-MNI/${pname}";
    description = "Collection of Perl and shell scripts for processing MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
  };
}
