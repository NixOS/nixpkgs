{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qmake,
  qttools,
  wrapQtAppsHook,
  boost,
  kirigami2,
  kyotocabinet,
  libmicrohttpd,
  libosmscout,
  libpostal,
  marisa,
  osrm-backend,
  protobuf,
  qtquickcontrols2,
  qtlocation,
  sqlite,
  valhalla,
}:

let
  date = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "a45ea7c17b4a7f320e199b71436074bd624c9e15";
    hash = "sha256-Mq7Yd+y8M3JNG9BEScwVEmxGWYEy6gaNNSlTGgR9LB4=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "osmscout-server";
  version = "3.1.5";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "osmscout-server";
    tag = finalAttrs.version;
    hash = "sha256-gmAHX7Gt2oAvTSTCypAjzI5a9TWOPDAYAMD1i1fJVUY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kirigami2
    qtquickcontrols2
    qtlocation
    valhalla
    libosmscout
    osrm-backend
    libmicrohttpd
    libpostal
    sqlite
    marisa
    kyotocabinet
    boost
    protobuf
    date
  ];

  qmakeFlags = [
    "SCOUT_FLAVOR=kirigami" # Choose to build the kirigami UI variant
    "CONFIG+=disable_mapnik" # Disable the optional mapnik backend
  ];

  meta = {
    description = "Maps server providing tiles, geocoder, and router";
    homepage = "https://github.com/rinigus/osmscout-server";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.Thra11 ];
    platforms = lib.platforms.linux;
  };
})
