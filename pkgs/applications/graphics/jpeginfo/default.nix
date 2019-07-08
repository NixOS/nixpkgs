{ stdenv, fetchurl, libjpeg }:

stdenv.mkDerivation rec {
  name = "jpeginfo-${version}";
  version = "1.6.1";

  src = fetchurl {
    url = "https://www.kokkonen.net/tjko/src/${name}.tar.gz";
    sha256 = "0lvn3pnylyj56158d3ix9w1gas1s29klribw9bz1xym03p7k37k2";
  };

  buildInputs = [ libjpeg ];

  meta = with stdenv.lib; {
    description = "Prints information and tests integrity of JPEG/JFIF files";
    homepage = "https://www.kokkonen.net/tjko/projects.html";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.bjornfor ];
    platforms = platforms.all;
  };
}
