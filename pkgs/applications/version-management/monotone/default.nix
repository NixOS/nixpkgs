{stdenv, fetchurl, boost, zlib, botan, libidn,
  lua, pcre, sqlite, lib}:

let 
  version = "0.45";
in stdenv.mkDerivation {
  name = "monotone-${version}";
  src = fetchurl {
    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.gz";
    sha256 = "64c734274715f392eb4a879172a11c0606d37c02b4a6f23045772af5f8e2a9ec";
  };
  buildInputs = [boost zlib botan libidn lua pcre sqlite];
  preConfigure = ''
    export sqlite_LIBS=-lsqlite3
    export NIX_LDFLAGS="$NIX_LDFLAGS -ldl"
  '';
  meta = {
    maintainers = [lib.maintainers.raskin];
  };
}
