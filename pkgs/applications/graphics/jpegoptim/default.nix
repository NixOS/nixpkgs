{ stdenv, fetchurl, libjpeg }:

stdenv.mkDerivation rec {
  version = "1.4.4";
  name = "jpegoptim-${version}";

  src = fetchurl {
    url = "http://www.kokkonen.net/tjko/src/${name}.tar.gz";
    sha256 = "1cn1i0g1xjdwa12w0ifbnzgb1vqbpr8ji6h05vxksj79vyi3x849";
  };

  # There are no checks, it seems.
  doCheck = false;

  buildInputs = [ libjpeg ];

  meta = with stdenv.lib; {
    description = "Optimize JPEG files";
    homepage = http://www.kokkonen.net/tjko/projects.html ;
    license = licenses.gpl2;
    maintainers = [ maintainers.aristid ];
    platforms = platforms.all;
  };
}
