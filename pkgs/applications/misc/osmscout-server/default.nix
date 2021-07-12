{ lib, mkDerivation, fetchFromGitHub, fetchpatch, pkg-config
, qmake, qttools, kirigami2, qtquickcontrols2, qtlocation
, libosmscout, mapnik, valhalla, libpostal, osrm-backend, protobuf
, libmicrohttpd_0_9_70, sqlite, marisa, kyotocabinet, boost
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
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "rinigus";
    repo = "osmscout-server";
    rev = version;
    sha256 = "0rpsi6nyhcz6bv0jab4vixkxhjmn84xi0q2xz15a097hn46cklx9";
    fetchSubmodules = true;
  };

  # Two patches required to work with valhalla 3.1
  patches = [
    # require C++14 to match latest Valhalla
    (fetchpatch {
      url = "https://github.com/rinigus/osmscout-server/commit/78b41b9b4c607fe9bfd6fbd61ae31cb7c8a725cd.patch";
      sha256 = "0gk9mdwa75awl0bj30gm8waj454d8k2yixxwh05m0p550cbv3lg0";
    })
    # add Valhalla 3.1 config
    (fetchpatch {
      url = "https://github.com/rinigus/osmscout-server/commit/584de8bd47700053960fa139a2d7f8d3d184c876.patch";
      sha256 = "0liz72n83q93bzzyyiqjkxa6hp9zjx7v9rgsmpwf88gc4caqm2dz";
    })
  ];

  nativeBuildInputs = [ qmake pkg-config qttools ];
  buildInputs = [
    kirigami2 qtquickcontrols2 qtlocation
    mapnik valhalla libosmscout osrm-backend libmicrohttpd_0_9_70
    libpostal sqlite marisa kyotocabinet boost protobuf date
  ];

  # OSMScout server currently defaults to an earlier version of valhalla,
  # but valhalla 3.1 support has been added. (See patches above)
  # Replace the default valhalla.json with the valhalla 3.1 version
  postPatch = ''
    mv data/valhalla.json-3.1 data/valhalla.json
  '';

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
