{
  lib,
  stdenv,
  fetchurl,
  sqlite,
}:

stdenv.mkDerivation rec {
  version = "3.4.1";
  pname = "libzdb";

  src = fetchurl {
    url = "https://www.tildeslash.com/libzdb/dist/libzdb-${version}.tar.gz";
    sha256 = "sha256-W0Yz/CoWiA93YZf0BF9i7421Bi9jAw+iIQEdS4XXNss=";
  };

  buildInputs = [ sqlite ];

  meta = {
    homepage = "http://www.tildeslash.com/libzdb/";
    description = "Small, easy to use Open Source Database Connection Pool Library";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
