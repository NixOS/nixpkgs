{ stdenv, pythonPackages, fetchurl, gettext
, pkgconfig, libofa, ffmpeg, chromaprint
}:

let
  version = "1.3.2";
in pythonPackages.buildPythonApplication {
  name = "picard-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "http://ftp.musicbrainz.org/pub/musicbrainz/picard/picard-${version}.tar.gz";
    sha256 = "0821xb7gyg0rhch8s3qkzmak90wjpcxkv9a364yv6bmqc12j6a77";
  };

  buildInputs = [
    pkgconfig
    ffmpeg
    libofa
    gettext
  ];

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
    homepage = "http://musicbrainz.org/doc/MusicBrainz_Picard";
    description = "The official MusicBrainz tagger";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
