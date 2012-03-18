{ stdenv, fetchurl, python, zlib, pkgconfig, glib, SDL, ncurses }:

stdenv.mkDerivation rec {
  name = "qemu-1.0.1";

  src = fetchurl {
    url = "http://wiki.qemu.org/download/${name}.tar.gz";
    sha256 = "0y43v5ls3j7iqczfswxkksiqww77nllydncygih7ylc20zhh528r";
  };

  buildInputs = [ python zlib pkgconfig glib SDL ncurses ];

  meta = {
    description = "QEmu processor emulator";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
