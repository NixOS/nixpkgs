{ stdenv, fetchurl, libmikmod, ncurses }:

stdenv.mkDerivation rec {
  name = "mikmod-3.2.2";
  src = fetchurl {
    url = "http://mikmod.shlomifish.org/files/${name}.tar.gz";
    sha256 = "105vl1kyah588wpbpq6ck1wlr0jj55l2ps72q5i01gs9px8ncmp8";
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
