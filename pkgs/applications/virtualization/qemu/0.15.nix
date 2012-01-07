{ stdenv, fetchurl, python, zlib, pkgconfig, glib, SDL, ncurses }:

stdenv.mkDerivation rec {
  name = "qemu-0.15.1";

  src = fetchurl {
    url = "http://wiki.qemu.org/download/${name}.tar.gz";
    sha256 = "1fmm7l7hm0vsmahp41pgvbl62hh833k802brn6hg8kcfkd6v21bp";
  };

  buildInputs = [ python zlib pkgconfig glib SDL ncurses ];

  meta = {
    description = "QEmu processor emulator";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
