{ stdenv, fetchurl, automoc4, cmake, perl, pkgconfig
, kdelibs, phonon, soprano, shared_desktop_ontologies
, kdemultimedia, taglib, glibc, gettext
}:

stdenv.mkDerivation rec {
  name = "bangarang-2.1";

  src = fetchurl {
    url = "http://bangarangissuetracking.googlecode.com/files/${name}.tar.gz";
    sha256 = "1g4pap79k8qaqi0py34xqvisxln1nc5hbvph692ah3af06n6cly1";
  };

  buildInputs = [
    kdelibs phonon soprano shared_desktop_ontologies kdemultimedia
    taglib gettext
  ];

  nativeBuildInputs = [ automoc4 cmake perl pkgconfig ];

  patches = [ ./gcc-4.7.patch ];

  meta = with stdenv.lib; {
    description = "A media player for KDE based on Nepomuk and Phonon";
    longDescription = ''
      Bangarang offers a minimalistic media center user interface,
      media collection management, playlists and statistics.
    '';
    homepage = http://bangarangkde.wordpress.com/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ maintainers.phreedom maintainers.urkud ];
    platforms = platforms.linux;
  };
}
