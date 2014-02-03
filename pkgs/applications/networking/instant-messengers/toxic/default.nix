{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, libtoxcore, pkgconfig }:

let
  version = "da99d776df";
  date = "20140203";
in
stdenv.mkDerivation rec {
  name = "toxic-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/Tox/toxic/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "0d97crkslyk7sgcsawnnwyzp31azp80yprpd6xqjcraxd442dfyj";
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
