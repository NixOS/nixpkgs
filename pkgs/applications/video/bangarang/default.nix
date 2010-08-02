{ stdenv, fetchurl, cmake, qt4, kdelibs, automoc4, phonon, soprano, kdemultimedia, taglib, glibc, gettext }:
stdenv.mkDerivation rec {
  name = "bangarang-1.0.1";

  src = fetchurl {
    url = "http://bangarangissuetracking.googlecode.com/files/${name}.tar.gz";
    sha256 = "0a89w6zqyzcb34vp3qmyp1mdm2k0igm71b5sh11xnikjvs3k7c33";
  };

  buildInputs = [ cmake qt4 kdelibs automoc4 phonon soprano kdemultimedia taglib glibc gettext ];

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
