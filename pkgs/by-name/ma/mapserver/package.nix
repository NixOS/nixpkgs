{
  lib,
  stdenv,
  fetchFromGitHub,

  withPython ? true,

  cairo,
  cmake,
  curl,
  fcgi,
  freetype,
  fribidi,
  gdal,
  geos,
  giflib,
  harfbuzz,
  libjpeg,
  libpng,
  librsvg,
  libxml2,
  pkg-config,
  postgresql,
  proj,
  protobufc,
  python3,
  swig,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "mapserver";
  version = "8.2.1";

  src = fetchFromGitHub {
    owner = "MapServer";
    repo = "MapServer";
    rev = "rel-${lib.replaceStrings [ "." ] [ "-" ] version}";
    hash = "sha256-kZEDC89yoQP0ma5avp6r+Hz8JMpErGlBVQkhlHO6UFw=";
  };

  nativeBuildInputs =
    [
      cmake
      pkg-config
    ]
    ++ lib.optionals withPython [
      swig
      python3.pkgs.setuptools
    ];

  buildInputs = [
    cairo
    curl
    fcgi
    freetype
    fribidi
    gdal
    geos
    giflib
    harfbuzz
    libjpeg
    libpng
    librsvg
    (libxml2.override { enableHttp = true; })
    postgresql
    proj
    protobufc
    zlib
  ] ++ lib.optional withPython python3;

  cmakeFlags = [
    "-DWITH_KML=ON"
    "-DWITH_SOS=ON"
    "-DWITH_RSVG=ON"
    "-DWITH_CURL=ON"
    "-DWITH_CLIENT_WMS=ON"
    "-DWITH_CLIENT_WFS=ON"

    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ] ++ lib.optional withPython "-DWITH_PYTHON=ON";

  meta = with lib; {
    description = "Platform for publishing spatial data and interactive mapping applications to the web";
    homepage = "https://mapserver.org/";
    changelog = "https://mapserver.org/development/changelog/";
    license = licenses.mit;
    maintainers = teams.geospatial.members;
    platforms = platforms.unix;
  };
}
