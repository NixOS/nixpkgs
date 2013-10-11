{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, tox_core, pkgconfig }:

let
  version = "75d356e52a";
  date = "20131011";
in
stdenv.mkDerivation rec {
  name = "toxic-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/Tox/toxic/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "14wyvms8l07sl88g8y6g2jv95sq7cnhbaqf4n32xxilch8rymq47";
  };

  preConfigure = ''
    autoreconf -i
  '';

  NIX_LDFLAGS = "-lsodium";

  configureFlags = [
    "--with-libtoxcore-headers=${tox_core}/include"
    "--with-libtoxcore-libs=${tox_core}/lib" 
    "--with-libsodium-headers=${tox_core}/include"
    "--with-libsodium-libs=${tox_core}/lib" 
  ];

  buildInputs = [ autoconf libtool automake tox_core libsodium ncurses pkgconfig ];

  doCheck = true;

  meta = {
    description = "Reference CLI for Tox";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
