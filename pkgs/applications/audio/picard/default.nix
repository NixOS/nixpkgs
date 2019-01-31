{ stdenv, python3Packages, fetchFromGitHub, gettext, chromaprint }:

let
  pythonPackages = python3Packages;
in pythonPackages.buildPythonApplication rec {
  pname = "picard";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = pname;
    rev = "release-${version}";
    sha256 = "1p2bvfzby0nk1vh04yfmsvjcldgkj6m6s1hcv9v13hc8q1cbdfk5";
  };

  buildInputs = [ gettext ];

  propagatedBuildInputs = with pythonPackages; [
    pyqt5
    mutagen
    chromaprint
    discid
  ];

  installPhase = ''
    python setup.py install --prefix="$out"
  '';

  prePatch = ''
    # Pesky unicode punctuation.
    substituteInPlace setup.cfg --replace "‘" "'"
  '';

  meta = with stdenv.lib; {
    homepage = http://musicbrainz.org/doc/MusicBrainz_Picard;
    description = "The official MusicBrainz tagger";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
