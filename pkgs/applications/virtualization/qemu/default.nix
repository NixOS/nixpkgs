{ stdenv, fetchurl, python, zlib, pkgconfig, glib, SDL, ncurses, perl, pixman
, attr, libcap }:

stdenv.mkDerivation rec {
  name = "qemu-1.4.0";

  src = fetchurl {
    url = "http://wiki.qemu.org/download/${name}.tar.bz2";
    sha256 = "1a7d11vjs1p6i1ck2ff9annmkhpkbjl73hl9i1cbg3s0fznrfqh6";
  };

  buildInputs = [
    python zlib pkgconfig glib SDL ncurses perl pixman attr libcap
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-virtfs"
  ];

  meta = {
    description = "QEmu processor emulator";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [ viric shlevy ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
