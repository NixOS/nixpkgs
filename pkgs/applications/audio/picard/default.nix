{ stdenv, python3Packages, fetchFromGitHub, gettext, chromaprint, qt5 }:

let
  pythonPackages = python3Packages;
in pythonPackages.buildPythonApplication rec {
  pname = "picard";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = pname;
    rev = "release-${version}";
    sha256 = "0xalg4dvaqb396h4s6gzxnplgv1lcvsczmmrlhyrj0kfj10amhsj";
  };

  nativeBuildInputs = [ gettext qt5.wrapQtAppsHook qt5.qtbase ];

  propagatedBuildInputs = with pythonPackages; [
    pyqt5
    mutagen
    chromaprint
    discid
  ];

  prePatch = ''
    # Pesky unicode punctuation.
    substituteInPlace setup.cfg --replace "‘" "'"
  '';

  installPhase = ''
    python setup.py install --prefix="$out"
    wrapQtApp $out/bin/picard
  '';

  meta = with stdenv.lib; {
    homepage = "https://picard.musicbrainz.org/";
    description = "The official MusicBrainz tagger";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
