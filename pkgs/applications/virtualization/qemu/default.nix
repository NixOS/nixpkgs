{ stdenv, fetchurl, python, zlib, pkgconfig, glib, SDL, ncurses, perl, pixman
, attr, libcap, vde2 }:

stdenv.mkDerivation rec {
  name = "qemu-1.5.1";

  src = fetchurl {
    url = "http://wiki.qemu.org/download/${name}.tar.bz2";
    sha256 = "1s7316pgizpayr472la8p8a4vhv7ymmzd5qlbkmq6y9q5zpa25ac";
  };

  buildInputs = [
    python zlib pkgconfig glib SDL ncurses perl pixman attr libcap
    vde2
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-virtfs"
    "--enable-vde"
  ];

  meta = {
    homepage = http://www.qemu.org/;
    description = "A generic and open source machine emulator and virtualizer";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [ viric shlevy eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
