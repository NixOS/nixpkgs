{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, libtoxcore, openal, libvpx, freealut, libconfig, pkgconfig }:

let
  version = "7566aa9d26";
  date = "20140728";
in
stdenv.mkDerivation rec {
  name = "toxic-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/Tox/toxic/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "13vns0qc0hxhab6rpz0irnzgv42mp3v1nrbwm90iymhf4xkc9nwa";
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
