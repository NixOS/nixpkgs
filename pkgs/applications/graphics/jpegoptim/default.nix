{ stdenv, fetchurl, libjpeg }:

stdenv.mkDerivation rec {
  version = "1.4.5";
  name = "jpegoptim-${version}";

  src = fetchurl {
    url = "http://www.kokkonen.net/tjko/src/${name}.tar.gz";
    sha256 = "1mngi8c4mhzwa7i4wqrqq6i80cqj4adbacblfvk6dy573wywyxmi";
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
