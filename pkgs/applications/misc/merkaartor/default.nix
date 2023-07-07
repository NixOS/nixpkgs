{ mkDerivation
, lib
, stdenv
, fetchFromGitHub
, qmake
, qttools
, qttranslations
, gdal
, proj
, qtsvg
, qtwebengine
, withGeoimage ? true, exiv2
, withGpsdlib ? (!stdenv.isDarwin), gpsd
, withLibproxy ? false, libproxy
, withZbar ? false, zbar
}:

mkDerivation rec {
  pname = "merkaartor";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "merkaartor";
    rev = version;
    sha256 = "sha256-I3QNCXzwhEFa8aOdwl3UJV8MLZ9caN9wuaaVrGFRvbQ=";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ gdal proj qtsvg qtwebengine ]
    ++ lib.optional withGeoimage exiv2
    ++ lib.optional withGpsdlib gpsd
    ++ lib.optional withLibproxy libproxy
    ++ lib.optional withZbar zbar;

  preConfigure = ''
    lrelease src/src.pro
  '';

  qmakeFlags = [
    "TRANSDIR_SYSTEM=${qttranslations}/translations"
    "USEWEBENGINE=1"
  ] ++ lib.optional withGeoimage "GEOIMAGE=1"
    ++ lib.optional withGpsdlib "GPSDLIB=1"
    ++ lib.optional withLibproxy "LIBPROXY=1"
    ++ lib.optional withZbar "ZBAR=1";

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv binaries/bin/merkaartor.app $out/Applications
    mv binaries/bin/plugins $out/Applications/merkaartor.app/Contents
  '';

  meta = with lib; {
    description = "OpenStreetMap editor";
    homepage = "http://merkaartor.be/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
