{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, libtoxcore, pkgconfig }:

let
  version = "b308e19e6b";
  date = "20140224";
in
stdenv.mkDerivation rec {
  name = "toxic-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/Tox/toxic/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "0fgkvnpy3dl2h378h796z9md0zg05b3174fgx17b919av6j9x4ma";
  };

  preConfigure = ''
    autoreconf -i
  '';

  NIX_LDFLAGS = "-lsodium";

  configureFlags = [
    "--with-libtoxcore-headers=${libtoxcore}/include"
    "--with-libtoxcore-libs=${libtoxcore}/lib" 
    "--with-libsodium-headers=${libtoxcore}/include"
    "--with-libsodium-libs=${libtoxcore}/lib" 
  ];

  buildInputs = [ autoconf libtool automake libtoxcore libsodium ncurses pkgconfig ];

  doCheck = true;

  meta = {
    description = "Reference CLI for Tox";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
