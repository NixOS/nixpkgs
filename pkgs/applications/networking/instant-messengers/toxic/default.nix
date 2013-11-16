{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, libtoxcore, pkgconfig }:

let
  version = "5570b7c98aa";
  date = "20131112";
in
stdenv.mkDerivation rec {
  name = "toxic-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/Tox/toxic/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "02jfdp10qcw4w62qpra59m9yzzk7a3k2nypkbq5q7ydksbqlx8sj";
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
