{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  desktopToDarwinBundle,
  curl,
  freexl,
  geos,
  librasterlite2,
  librttopo,
  libspatialite,
  libwebp,
  libxlsxwriter,
  libxml2,
  lz4,
  minizip,
  openjpeg,
  postgresql,
  proj,
  sqlite,
  virtualpg,
  wxGTK,
  xz,
  zstd,
  Carbon,
  Cocoa,
  IOKit,
}:

stdenv.mkDerivation rec {
  pname = "spatialite-gui";
  version = "2.1.0-beta1";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-${version}.tar.gz";
    hash = "sha256-ukjZbfGM68P/I/aXlyB64VgszmL0WWtpuuMAyjwj2zM=";
  };

  nativeBuildInputs = [ pkg-config ] ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;

  buildInputs =
    [
      curl
      freexl
      geos
      librasterlite2
      librttopo
      libspatialite
      libwebp
      libxlsxwriter
      libxml2
      lz4
      minizip
      openjpeg
      postgresql
      proj
      sqlite
      virtualpg
      wxGTK
      xz
      zstd
    ]
    ++ lib.optionals stdenv.isDarwin [
      Carbon
      Cocoa
      IOKit
    ];

  enableParallelBuilding = true;

  postFixup = lib.optionalString stdenv.isDarwin ''
    rm -fr $out/share
  '';

  meta = with lib; {
    description = "Graphical user interface for SpatiaLite";
    homepage = "https://www.gaia-gis.it/fossil/spatialite_gui";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = teams.geospatial.members;
    mainProgram = "spatialite_gui";
  };
}
