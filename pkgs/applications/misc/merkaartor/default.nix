{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, qmake
, qttools
, wrapQtAppsHook
, gdal
, proj
, qtsvg
, qtwebengine
, withGeoimage ? true, exiv2
, withGpsdlib ? (!stdenv.isDarwin), gpsd
, withLibproxy ? false, libproxy
, withZbar ? false, zbar
}:

stdenv.mkDerivation rec {
  pname = "merkaartor";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "merkaartor";
    rev = version;
    hash = "sha256-I3QNCXzwhEFa8aOdwl3UJV8MLZ9caN9wuaaVrGFRvbQ=";
  };

  patches = [
    (fetchpatch {
      name = "exiv2-0.28.patch";
      url = "https://github.com/openstreetmap/merkaartor/commit/1e20d2ccd743ea5f8c2358e4ae36fead8b9390fd.patch";
      hash = "sha256-aHjJLKYvqz7V0QwUIg0SbentBe+DaCJusVqy4xRBVWo=";
    })
  ];

  nativeBuildInputs = [ qmake qttools wrapQtAppsHook ];

  buildInputs = [ gdal proj qtsvg qtwebengine ]
    ++ lib.optional withGeoimage exiv2
    ++ lib.optional withGpsdlib gpsd
    ++ lib.optional withLibproxy libproxy
    ++ lib.optional withZbar zbar;

  preConfigure = ''
    lrelease src/src.pro
  '';

  qmakeFlags = [
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
