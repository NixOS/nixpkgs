{ mkDerivation
, lib
, stdenv
, fetchFromGitHub
, fetchpatch
, qmake
, qttools
, qttranslations
, gdal
, proj
, qtsvg
, qtwebkit
, withGeoimage ? true, exiv2
, withGpsdlib ? (!stdenv.isDarwin), gpsd
, withLibproxy ? false, libproxy
, withZbar ? false, zbar
}:

mkDerivation rec {
  pname = "merkaartor";
  version = "0.18.4";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "merkaartor";
    rev = version;
    sha256 = "vwO4/a7YF9KbpxcFGTFCdG6SfwEyhISlEtcA+rMebUA=";
  };

  patches = [
    # Fix build with Qt 5.15 (missing QPainterPath include)
    (fetchpatch {
      url = "https://github.com/openstreetmap/merkaartor/commit/e72553a7ea2c7ba0634cc3afcd27a9f7cfef089c.patch";
      sha256 = "NAisplnS3xHSlRpX+fH15NpbaD+uM57OCsTYGKlIR7U=";
    })
    # Added a condition to use the new timespec_t on gpsd APIs >= 9
    (fetchpatch {
      url = "https://github.com/openstreetmap/merkaartor/commit/13b358fa7899bb34e277b32a4c0d92833050f2c6.patch";
      sha256 = "129fpjm7illz7ngx3shps5ivrxwf14apw55842xhskwwb0rf5szb";
    })
  ];

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ gdal proj qtsvg qtwebkit ]
    ++ lib.optional withGeoimage exiv2
    ++ lib.optional withGpsdlib gpsd
    ++ lib.optional withLibproxy libproxy
    ++ lib.optional withZbar zbar;

  preConfigure = ''
    lrelease src/src.pro
  '';

  qmakeFlags = [ "TRANSDIR_SYSTEM=${qttranslations}/translations" ]
    ++ lib.optional withGeoimage "GEOIMAGE=1"
    ++ lib.optional withGpsdlib "GPSDLIB=1"
    ++ lib.optional withLibproxy "LIBPROXY=1"
    ++ lib.optional withZbar "ZBAR=1";

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv binaries/bin/merkaartor.app $out/Applications
    mv binaries/bin/plugins $out/Applications/merkaartor.app/Contents
    wrapQtApp $out/Applications/merkaartor.app/Contents/MacOS/merkaartor
  '';

  meta = with lib; {
    description = "OpenStreetMap editor";
    homepage = "http://merkaartor.be/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
