{ stdenv, fetchurl, libmikmod, ncurses, alsaLib }:

stdenv.mkDerivation rec {
  name = "mikmod-3.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/mikmod/${name}.tar.gz";
    sha256 = "0wr61raj10rpl64mk3x9g3rwys898fbzyg93c6mrz89nvc74wm04";
  };

  buildInputs = [ libmikmod ncurses ];

  meta = {
    description = "Tracker music player for the terminal";
    homepage = http://mikmod.shlomifish.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
