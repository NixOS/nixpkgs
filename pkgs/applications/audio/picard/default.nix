{ stdenv, python3Packages, fetchurl, gettext, chromaprint }:

let
  pythonPackages = python3Packages;
in pythonPackages.buildPythonApplication rec {
  pname = "picard";
  version = "2.1";

  src = fetchurl {
    url = "http://ftp.musicbrainz.org/pub/musicbrainz/picard/picard-${version}.tar.gz";
    sha256 = "054a37q5828q59jzml4npkyczsp891d89kawgsif9kwpi0dxa06c";
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
