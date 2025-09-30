{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gdal,
  proj,
  protobuf,
  qt6,
  withGeoimage ? true,
  exiv2,
  withGpsdlib ? (!stdenv.hostPlatform.isDarwin),
  gpsd,
  withLibproxy ? false,
  libproxy,
  withZbar ? false,
  zbar,
}:

stdenv.mkDerivation rec {
  pname = "merkaartor";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "merkaartor";
    tag = version;
    hash = "sha256-oxLGhIE1qJ9+GOztD1HvrLGRGVO3gyy7Rc6CyzKTFec=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    gdal
    proj
    protobuf
    qt6.qt5compat
    qt6.qtnetworkauth
    qt6.qtsvg
    qt6.qtwebengine
  ]
  ++ lib.optional withGeoimage exiv2
  ++ lib.optional withGpsdlib gpsd
  ++ lib.optional withLibproxy libproxy
  ++ lib.optional withZbar zbar;

  cmakeFlags = [
    (lib.cmakeBool "GEOIMAGE" withGeoimage)
    (lib.cmakeBool "GPSD" withGpsdlib)
    (lib.cmakeBool "LIBPROXY" withLibproxy)
    (lib.cmakeBool "WEBENGINE" true)
    (lib.cmakeBool "ZBAR" withZbar)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/merkaartor.app $out/Applications
    # Prevent wrapping, otherwise plugins will not be loaded
    chmod -x $out/Applications/merkaartor.app/Contents/plugins/background/*.dylib
    makeWrapper $out/{Applications/merkaartor.app/Contents/MacOS,bin}/merkaartor
  '';

  meta = {
    description = "OpenStreetMap editor";
    homepage = "https://merkaartor.be/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "merkaartor";
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
}
