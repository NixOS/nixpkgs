{ stdenv, fetchgit
, guile, pkgconfig, glib, loudmouth, gmp, libidn, readline, libtool
, libunwind, ncurses, curl, jansson, texinfo
, automake, autoconf
}:

let
  s = rec {
    baseName="freetalk";
    version="4.0rc6";
    name="${baseName}-${version}";
    url="https://github.com/GNUFreetalk/freetalk";
    rev = "refs/tags/v${version}";
    sha256="0vh6snkd66gdzimdiyy9idhsip60d5xc7qh4w48k7n8h93ydrb2b";
  };
  buildInputs = [
    guile pkgconfig glib loudmouth gmp libidn readline libtool
    libunwind ncurses curl jansson texinfo
    autoconf automake
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchgit {
    inherit (s) url rev sha256;
  };

  preConfigure = ''
    patchShebangs .
    ./autogen.sh
  '';

  meta = {
    inherit (s) version;
    description =  "Console XMPP client";
    license = stdenv.lib.licenses.gpl3Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    downloadPage = "http://www.gnu.org/software/freetalk/";
  };
}
