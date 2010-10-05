{ stdenv, fetchurl, kdelibs, cmake, qt4, automoc4, phonon, kdebase, gettext  }:

stdenv.mkDerivation rec {
  name = "konq-plugins-${version}";
  version = "4.4.0";

  src = fetchurl { 
    url = http://ftp.riken.go.jp/pub/FreeBSD/distfiles/KDE/extragear/konq-plugins-4.4.0.tar.bz2;
    sha256 = "1hn722rcdcwmhfnn89rnvp2b4d8gds4nm483ps3jkk83d7f2xmbi";
  };

  buildInputs = [ cmake kdelibs qt4 automoc4 phonon kdebase gettext ];

  meta = with stdenv.lib; {
    description = "Various plugins for Konqueror";
    license = "GPL";
    homepage = http://kde.org/;
    maintainers = [ maintainers.phreedom ];
    platforms =  kdelibs.meta.platforms;
  };
}
