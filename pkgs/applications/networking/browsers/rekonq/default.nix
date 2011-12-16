{ stdenv, fetchurl, kdelibs, gettext}:

stdenv.mkDerivation rec {
  name = "rekonq-0.8.1";

  src = fetchurl {
    url = "mirror://sf/rekonq/${name}.tar.bz2";
    sha256 = "0zwvdk66q9iphdkrhn850p9f0h8lads9qx3v6dnq15gfk793nz4h";
  };

  buildInputs = [ kdelibs ];

  buildNativeInputs = [ gettext ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.urkud ];
    description = "KDE Webkit browser";
    homepage = http://rekonq.sourceforge.net;
  };
}
