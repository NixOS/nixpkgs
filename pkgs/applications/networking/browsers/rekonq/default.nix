{ stdenv, fetchurl, kdelibs, gettext}:

stdenv.mkDerivation rec {
  name = "rekonq-0.9.0-1";

  src = fetchurl {
    url = "mirror://sf/rekonq/${name}.tar.bz2";
    sha256 = "0vri6wdxxi7qkcjpgvscwa7m3ysy62jns924d07arvy8bmg5whc5";
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
