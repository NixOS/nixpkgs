{ stdenv, python3Packages, fetchurl, gettext, chromaprint }:

let
  pythonPackages = python3Packages;
in pythonPackages.buildPythonApplication rec {
  pname = "picard";
  version = "2.0.4";

  src = fetchurl {
    url = "http://ftp.musicbrainz.org/pub/musicbrainz/picard/picard-${version}.tar.gz";
    sha256 = "0ds3ylpqn717fnzcjrfn05v5xram01bj6n3hwn9igmkd1jgf8vhc";
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

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://musicbrainz.org/doc/MusicBrainz_Picard;
    description = "The official MusicBrainz tagger";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
