{ stdenv, fetchurl, libjpeg }:

stdenv.mkDerivation rec {
  version = "1.4.6";
  name = "jpegoptim-${version}";

  src = fetchurl {
    url = "https://www.kokkonen.net/tjko/src/${name}.tar.gz";
    sha256 = "1dss7907fclfl8zsw0bl4qcw0hhz6fqgi3867w0jyfm3q9jfpcc8";
  };

  # There are no checks, it seems.
  doCheck = false;

  buildInputs = [ libjpeg ];

  meta = with stdenv.lib; {
    description = "Optimize JPEG files";
    homepage = https://www.kokkonen.net/tjko/projects.html ;
    license = licenses.gpl2;
    maintainers = [ maintainers.aristid ];
    platforms = platforms.all;
  };
}
