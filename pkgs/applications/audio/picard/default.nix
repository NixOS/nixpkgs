{ stdenv, python2Packages, fetchurl, gettext, chromaprint }:

let
  version = "1.4";
  pythonPackages = python2Packages;
in pythonPackages.buildPythonApplication {
  name = "picard-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "http://ftp.musicbrainz.org/pub/musicbrainz/picard/picard-${version}.tar.gz";
    sha256 = "0gi7f1h7jcg7n18cx8iw38sd868viv3w377xmi7cq98f1g76d4h6";
  };

  buildInputs = [ gettext ];

  propagatedBuildInputs = with pythonPackages; [
    pyqt4
    mutagen
    discid
  ];

  installPhase = ''
    python setup.py install --prefix="$out"
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://musicbrainz.org/doc/MusicBrainz_Picard;
    description = "The official MusicBrainz tagger";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
