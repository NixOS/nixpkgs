{ lib, mkDerivation, fetchFromGitHub, pkg-config
, qmake, qttools, kirigami2, qtquickcontrols2, qtlocation
, libosmscout, valhalla, libpostal, osrm-backend, protobuf
, libmicrohttpd, sqlite, marisa, kyotocabinet, boost
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
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "osmscout-server";
    rev = version;
    sha256 = "sha256-ngB3c6rUQ/+AeaJHKAFRl9lCkUobLWSnsn030brB+Bw=";
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
