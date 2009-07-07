{stdenv, fetchurl, boost, zlib, botan, libidn,
  lua, pcre, sqlite, lib}:

let 
  version = "0.44";
in stdenv.mkDerivation {
  name = "monotone-${version}";
  src = fetchurl {
    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.gz";
    sha256 = "1d1jck5dw210q99km5akz1bsk447sybypdwwi07v1836jkgk0wll";
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
