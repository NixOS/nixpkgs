{ stdenv, fetchurl, pythonPackages, gettext, pyqt4
, pkgconfig, libdiscid, libofa, ffmpeg, chromaprint
}:

pythonPackages.buildPythonPackage rec {
  name = "picard-${version}";
  namePrefix = "";
  version = "1.2";

  src = fetchurl {
    url = "http://ftp.musicbrainz.org/pub/musicbrainz/picard/${name}.tar.gz";
    sha256 = "0sbsf8hzxhxcnnjqvsd6mc23lmk7w33nln0f3w72f89mjgs6pxm6";
  };

  postPatch = let
    discid = "${libdiscid}/lib/libdiscid.so.0";
    fpr = "${chromaprint}/bin/fpcalc";
  in ''
    substituteInPlace picard/disc.py --replace libdiscid.so.0 ${discid}
    substituteInPlace picard/const.py \
        --replace "FPCALC_NAMES = [" "FPCALC_NAMES = ['${fpr}',"
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

  meta = with stdenv.lib; {
    homepage = "http://musicbrainz.org/doc/MusicBrainz_Picard";
    description = "The official MusicBrainz tagger";
    maintainers = with maintainers; [ emery ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
