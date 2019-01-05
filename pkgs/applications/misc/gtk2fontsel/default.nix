{stdenv, fetchurl, pkgconfig, gtk }:

stdenv.mkDerivation rec {
  version = "0.1";
  name = "gtk2fontsel-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gtk2fontsel/${name}.tar.gz";
    sha256 = "0s2sj19n8ys92q9832hkn36ld91bb4qavicc6nygkry6qdpkkmjw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ stdenv gtk ];

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "A font selection program for X11 using the GTK2 toolkit";
    longDescription = ''
      Font selection tool similar to xfontsel implemented using GTK+ 2.
      Trivial, but useful nonetheless.
    '';
    homepage = http://gtk2fontsel.sourceforge.net/;
    downloadPage = https://sourceforge.net/projects/gtk2fontsel/;
    license = licenses.gpl2;
    maintainers = [ maintainers.prikhi ];
    platforms = platforms.linux;
  };
}
