{ stdenv, buildPythonPackage, fetchurl, gettext
, pkgconfig, libofa, ffmpeg, chromaprint
, pyqt4, mutagen, python-libdiscid
}:

let version = "1.3"; in
buildPythonPackage {
  name = "picard-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "ftp://ftp.musicbrainz.org/pub/musicbrainz/picard/picard-${version}.tar.gz";
    sha256 = "06s90w1j29qhd931dgj752k5v4pjbvxiz6g0613xzj3ms8zsrlys";
  };

  buildInputs = [
    pkgconfig
    ffmpeg
    libofa
    gettext
  ];

  propagatedBuildInputs = [
    pyqt4
    mutagen
    python-libdiscid
  ];

  installPhase = ''
    python setup.py install --prefix="$out"
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://musicbrainz.org/doc/MusicBrainz_Picard";
    description = "The official MusicBrainz tagger";
    maintainers = with maintainers; [ emery ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
