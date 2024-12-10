{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, pkg-config
, qmake
, qttools
, boost
, kirigami2
, kyotocabinet
, libmicrohttpd
, libosmscout
, libpostal
, marisa
, osrm-backend
, protobuf
, qtquickcontrols2
, qtlocation
, sqlite
, valhalla
}:

let
  date = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "a2fdba1adcb076bf9a8343c07524afdf09aa8dcc";
    sha256 = "00sf1pbaz0g0gsa0dlm23lxk4h46xm1jv1gzbjj5rr9sf1qccyr5";
  };
in
mkDerivation rec {
  pname = "osmscout-server";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "osmscout-server";
    rev = version;
    hash = "sha256-GqUXHn3ZK8gdDlm3TitEp/jhBpQoVeQZUCfAyiyrDEg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake pkg-config qttools ];
  buildInputs = [
    kirigami2 qtquickcontrols2 qtlocation
    valhalla libosmscout osrm-backend libmicrohttpd
    libpostal sqlite marisa kyotocabinet boost protobuf date
  ];

  qmakeFlags = [
    "SCOUT_FLAVOR=kirigami" # Choose to build the kirigami UI variant
    "CONFIG+=disable_mapnik" # Disable the optional mapnik backend
  ];

  meta = with lib; {
    description = "Maps server providing tiles, geocoder, and router";
    homepage = "https://github.com/rinigus/osmscout-server";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
