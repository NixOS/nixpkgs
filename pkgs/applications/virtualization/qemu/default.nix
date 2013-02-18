{ stdenv, fetchurl, python, zlib, pkgconfig, glib, SDL, ncurses, perl, pixman }:

stdenv.mkDerivation rec {
  name = "qemu-1.3.1";

  src = fetchurl {
    url = "http://wiki.qemu.org/download/${name}.tar.bz2";
    sha256 = "1bqfrb5dlsxm8gxhkksz8qzi5fhj3xqhxyfwbqcphhcv1kpyfwip";
  };

  buildInputs = [ python zlib pkgconfig glib SDL ncurses perl pixman ];

  enableParallelBuilding = true;

  meta = {
    description = "QEmu processor emulator";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [ viric shlevy ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
