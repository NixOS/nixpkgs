{ lib, mkDerivation, fetchFromGitHub, fetchpatch, pkg-config
, qmake, qttools, kirigami2, qtquickcontrols2, qtlocation
, libosmscout, mapnik, valhalla, libpostal, osrm-backend, protobuf
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
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "osmscout-server";
    rev = version;
    sha256 = "01j1vwxyflfv6dhhgisv1a2v841xyx8ccas0q79g575s1lg6y765";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake pkg-config qttools ];
  buildInputs = [
    kirigami2 qtquickcontrols2 qtlocation
    mapnik valhalla libosmscout osrm-backend libmicrohttpd
    libpostal sqlite marisa kyotocabinet boost protobuf date
  ];

  # Choose to build the kirigami UI variant
  qmakeFlags = [ "SCOUT_FLAVOR=kirigami" ];

  meta = with lib; {
    description = "Maps server providing tiles, geocoder, and router";
    homepage = "https://github.com/rinigus/osmscout-server";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
