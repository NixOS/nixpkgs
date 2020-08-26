{ stdenv, fetchFromGitHub, cmake, pkgconfig, libminc, bicpl, itk4, fftwFloat, gsl }:

stdenv.mkDerivation rec {
  pname = "EZminc";
  name  = "${pname}-unstable-2019-03-12";

  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = pname;
    rev    = "5e3333ee356f914d34d66d33ea8df809c7f7fa51";
    sha256 = "0wy8cppf5xpgfqvgb3mqs1cjh81n6qzkk6zxv29wvng8nar9wsy4";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ itk4 libminc bicpl fftwFloat gsl ];

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
