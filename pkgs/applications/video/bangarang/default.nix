{ stdenv, fetchurl, cmake, qt4, kdelibs, automoc4, phonon, soprano, shared_desktop_ontologies, kdemultimedia, taglib, glibc, gettext }:
stdenv.mkDerivation rec {
  name = "bangarang-2.0";

  src = fetchurl {
    url = "http://bangarangissuetracking.googlecode.com/files/${name}.tar.gz";
    sha256 = "1fixqx56k0mk0faz35rzpdg6zaa0mvm4548rg0g7fhafl35fxzlz";
  };

  buildInputs = [ cmake qt4 kdelibs automoc4 phonon soprano shared_desktop_ontologies kdemultimedia taglib glibc gettext ];

  meta = with stdenv.lib; {
    description = "A media player for KDE based on Nepomuk and Phonon";
    longDescription = ''
      Bangarang offers a minimalistic media center user interface,
      media collection management, playlists and statistics.
    '';
    homepage = http://bangarangkde.wordpress.com/;
    license = "GPLv3";
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}
