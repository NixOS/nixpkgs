{ stdenv, fetchurl, libjpeg }:

stdenv.mkDerivation rec {
  version = "1.4.3";
  name = "jpegoptim-${version}";

  src = fetchurl {
    url = "http://www.kokkonen.net/tjko/src/${name}.tar.gz";
    sha256 = "0k53q7dc8w5ashz8v261x2b5vvz7gdvg8w962rz9gjvkjbh4lg93";
  };

  # There are no checks, it seems.
  doCheck = false;

  buildInputs = [ libjpeg ];

  meta = {
    description = "Optimize JPEG files";
    homepage = http://www.kokkonen.net/tjko/projects.html ;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.aristid ];
    platforms = stdenv.lib.platforms.all;
  };
}
