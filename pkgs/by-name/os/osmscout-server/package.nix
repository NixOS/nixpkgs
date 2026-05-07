{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  boost,
  libsForQt5,
  kyotocabinet,
  libmicrohttpd,
  libosmscout,
  libpostal,
  marisa,
  osrm-backend,
  protobuf_21,
  sqlite,
  valhalla,
  abseil-cpp_202103,
}:

let
  date = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "a45ea7c17b4a7f320e199b71436074bd624c9e15";
    hash = "sha256-Mq7Yd+y8M3JNG9BEScwVEmxGWYEy6gaNNSlTGgR9LB4=";
  };
  protobuf' = protobuf_21.override {
    abseil-cpp = abseil-cpp_202103.override {
      cxxStandard = "17";
    };
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
    libsForQt5.qmake
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.kirigami2
    libsForQt5.qtquickcontrols2
    libsForQt5.qtlocation
    valhalla
    libosmscout
    osrm-backend
    libmicrohttpd
    libpostal
    sqlite
    marisa
    kyotocabinet
    boost
    protobuf'
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
