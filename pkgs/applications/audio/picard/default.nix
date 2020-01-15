{ stdenv, python3Packages, fetchFromGitHub, gettext, chromaprint, qt5 }:

let
  pythonPackages = python3Packages;
in pythonPackages.buildPythonApplication rec {
  pname = "picard";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = pname;
    rev = "release-${version}";
    sha256 = "1armg8vpvnbpk7rrfk9q7nj5gm56rza00ni9qwdyqpxp1xaz6apj";
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
    homepage = http://musicbrainz.org/doc/MusicBrainz_Picard;
    description = "The official MusicBrainz tagger";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
