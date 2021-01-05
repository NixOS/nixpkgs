{ mkDerivation, lib, fetchFromGitHub, qmake, pkgconfig, fetchpatch
, boost, gdal, proj, qtbase, qtsvg, qtwebview, qtwebkit }:

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
    (fetchpatch {
      url = "https://github.com/openstreetmap/merkaartor/commit/e72553a7ea2c7ba0634cc3afcd27a9f7cfef089c.patch";
      sha256 = "NAisplnS3xHSlRpX+fH15NpbaD+uM57OCsTYGKlIR7U=";
    })
  ];

  nativeBuildInputs = [ qmake pkgconfig ];

  buildInputs = [ boost gdal proj qtbase qtsvg qtwebview qtwebkit ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H";

  meta = with lib; {
    description = "OpenStreetMap editor";
    homepage = "http://merkaartor.be/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
