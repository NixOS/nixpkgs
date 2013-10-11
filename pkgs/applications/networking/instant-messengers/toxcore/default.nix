{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, libconfig, pkgconfig }:

let
  version = "31f5d7a8ab";
  date = "20131011";
in
stdenv.mkDerivation rec {
  name = "tox-core-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/irungentoo/ProjectTox-Core/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "0frz8ylvi33i7zkiz3hp28ylqg4c3ffrbc2m3ibb4zv9rwfzf77r";
  };

  preConfigure = ''
    autoreconf -i
  '';

  configureFlags = [ "--with-libsodium-headers=${libsodium}/include"
    "--with-libsodium-libs=${libsodium}/lib" 
    "--enable-ntox" ];

  buildInputs = [ autoconf libtool automake libsodium ncurses libconfig
    pkgconfig ];

  doCheck = true;

  meta = {
    description = "P2P FOSS instant messaging application aimed to replace Skype with crypto";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
