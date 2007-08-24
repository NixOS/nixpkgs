{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cdrtools-2.01";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.berlios.de/pub/cdrecord/cdrtools-2.01.tar.bz2;
    md5 = "d44a81460e97ae02931c31188fe8d3fd";
  };
  patches = [./cdrtools-2.01-install.patch];
}
