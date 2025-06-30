{
  lib,
  stdenv,
  fetchurl,
  validatePkgConfig,
  expat,
  minizip,
  zlib,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "freexl";
  version = "2.0.0";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/freexl-${version}.tar.gz";
    hash = "sha256-F2cF8d5Yq3we679cbeRqt2/Ni4VlCNvSj1ZI98bhp/A=";
  };

  nativeBuildInputs = [ validatePkgConfig ];

  buildInputs = [
    expat
    minizip
    zlib
  ] ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Library to extract valid data from within an Excel (.xls) spreadsheet";
    homepage = "https://www.gaia-gis.it/fossil/freexl";
    # They allow any of these
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
      mpl11
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
