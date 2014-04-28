{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, libtoxcore, pkgconfig }:

let
  version = "328e7f8d57";
  date = "20140611";
in
stdenv.mkDerivation rec {
  name = "toxic-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/Tox/toxic/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "0kwry6855cwpjb7knfc4a01z1i6q4shmi3zh1aw45vd4ardrc91i";
  };

  preConfigure = "autoreconf -i";

  buildInputs = [ autoconf libtool automake libtoxcore libsodium ncurses pkgconfig ];

  meta = {
    description = "Reference CLI for Tox";
    homepage = https://github.com/Tox/toxic;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ viric emery ];
    platforms = stdenv.lib.platforms.all;
  };
}
