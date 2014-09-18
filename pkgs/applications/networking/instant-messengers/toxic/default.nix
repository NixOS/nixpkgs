{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, libtoxcore, openal, libvpx, freealut, libconfig, pkgconfig }:

let
  version = "0.5.0";
in stdenv.mkDerivation rec {
  name = "toxic-${version}";

  src = fetchurl {
    url = "https://github.com/Tox/toxic/archive/v${version}.tar.gz";
    sha256 = "01k32431zay1mdqvrw5qk0pjxb7gkcxr78w1a06g23b7ymjwfawv";
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
