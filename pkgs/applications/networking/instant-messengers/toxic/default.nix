{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, libtoxcore, openal, libvpx, freealut, libconfig, pkgconfig }:

let
  version = "0.4.7";
in stdenv.mkDerivation rec {
  name = "toxic-${version}";

  src = fetchurl {
    url = "https://github.com/Tox/toxic/archive/v${version}.tar.gz";
    sha256 = "0rcrcqzvicz7787fa4b7f68qnwq6wqbyrm8ii850f1w7vnxq9dkq";
  };

  makeFlags = [ "-Cbuild" "VERSION=${version}" ];
  installFlags = [ "PREFIX=$(out)" ];

  buildInputs = [
    autoconf libtool automake libtoxcore libsodium ncurses openal libvpx
    freealut libconfig pkgconfig
  ];

  meta = {
    description = "Reference CLI for Tox";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
