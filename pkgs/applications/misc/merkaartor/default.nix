{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  qttools,
  wrapQtAppsHook,
  gdal,
  proj,
  qtsvg,
  qtwebengine,
  withGeoimage ? true,
  exiv2,
  withGpsdlib ? (!stdenv.isDarwin),
  gpsd,
  withLibproxy ? false,
  libproxy,
  withZbar ? false,
  zbar,
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
    # https://github.com/openstreetmap/merkaartor/pull/290
    (fetchpatch {
      url = "https://github.com/openstreetmap/merkaartor/commit/7dede77370d89e8e7586f6ed5af225f9b5bde6cf.patch";
      hash = "sha256-3oDRPysVNvA50t/b9xOcVQgac3U1lDPrencanl4c6Zk=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs =
    [
      gdal
      proj
      qtsvg
      qtwebengine
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

  postInstall =
    ''
      # Binary is looking for .qm files in share/merkaartor
      mv $out/share/merkaartor/{translations/*.qm,}
      rm -r $out/share/merkaartor/translations
    ''
    + lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/{Applications,bin}
      mv $out/merkaartor.app $out/Applications
      # Prevent wrapping, otherwise plugins will not be loaded
      chmod -x $out/Applications/merkaartor.app/Contents/plugins/background/*.dylib
      makeWrapper $out/{Applications/merkaartor.app/Contents/MacOS,bin}/merkaartor
    '';

  meta = with lib; {
    description = "OpenStreetMap editor";
    homepage = "http://merkaartor.be/";
    license = licenses.gpl2Plus;
    mainProgram = "merkaartor";
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
