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
    sha256="0sj3bwq9n6ijwv552nmi038sz7wayq8r3zaj6ngn2cnkn2b5nwbz";
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
    name = "git-export-${s.name}";
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
