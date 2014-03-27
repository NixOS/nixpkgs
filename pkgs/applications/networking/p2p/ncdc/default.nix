{ stdenv, fetchurl, ncurses, zlib, bzip2, sqlite, pkgconfig, glib, gnutls }:

stdenv.mkDerivation rec {
  name = "ncdc-${version}";
  version = "1.19";

  src = fetchurl {
    url = "http://dev.yorhel.nl/download/ncdc-1.19.tar.gz";
    sha256 = "1wgvqwfxq9kc729h2r528n55821w87sfbm4h21mr6pvkpfw30hf2";
  };

  buildInputs = [ ncurses zlib bzip2 sqlite pkgconfig glib gnutls ];

  meta = {
    description = "modern and lightweight direct connect client with a friendly ncurses interface";
    homepage = http://dev.yorhel.nl/ncdc;
    license = stdenv.lib.licenses.mit;
  };
}
