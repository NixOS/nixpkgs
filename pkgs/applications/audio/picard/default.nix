{ stdenv, fetchurl, pythonPackages, gettext, pyqt4
, pkgconfig, libdiscid, libofa, ffmpeg }:

pythonPackages.buildPythonPackage rec {
  name = "picard-${version}";
  namePrefix = "";
  version = "1.1";

  src = fetchurl {
    url = "http://ftp.musicbrainz.org/pub/musicbrainz/picard/${name}.tar.gz";
    md5 = "57abb76632a423760f336ac11da5c149";
  };

  buildInputs = [
    pkgconfig
    ffmpeg
    libofa
    gettext
  ];

  propagatedBuildInputs = [
    pythonPackages.mutagen
    pyqt4
    libdiscid
  ];

  configurePhase = ''
    python setup.py config
  '';

  buildPhase = ''
    python setup.py build
  '';

  installPhase = ''
    python setup.py install --prefix="$out"
  '';

  doCheck = false;

  meta = {
    homepage = "http://musicbrainz.org/doc/MusicBrainz_Picard";
    description = "The official MusicBrainz tagger";
    license = stdenv.lib.licenses.gpl2;
  };
}
