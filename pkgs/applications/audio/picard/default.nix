{ stdenv, fetchurl, pythonPackages, gettext, pyqt4
, pkgconfig, libdiscid, libofa, ffmpeg, acoustidFingerprinter
}:

pythonPackages.buildPythonPackage rec {
  name = "picard-${version}";
  namePrefix = "";
  version = "1.2";

  src = fetchurl {
    url = "http://ftp.musicbrainz.org/pub/musicbrainz/picard/${name}.tar.gz";
    md5 = "d1086687b7f7b0d359a731b1a25e7b66";
  };

  postPatch = let
    fpr = "${acoustidFingerprinter}/bin/acoustid-fingerprinter";
  in ''
    sed -ri -e 's|(TextOption.*"acoustid_fpcalc"[^"]*")[^"]*|\1${fpr}|' \
      picard/ui/options/fingerprinting.py
  '';

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
