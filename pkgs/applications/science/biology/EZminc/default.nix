{ stdenv, fetchFromGitHub, cmake, libminc, bicpl, itk, fftwFloat, gsl }:

stdenv.mkDerivation rec { pname = "EZminc";
  name  = "${pname}-2017-08-29";

  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = pname;
    rev    = "4e017236cb6e7f6e07507446b18b759c584b6fc3";
    sha256 = "1pg06x42pgsg7zy7dz9wf6ajakkm2n8by64lg9z64qi8qqy82b8v";
  };

  nativeBuildInputs = [ cmake ];
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
