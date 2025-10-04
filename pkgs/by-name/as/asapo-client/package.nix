{
  stdenv,
  lib,
  fetchurl,
  cmake,
  curl,
  rapidjson,
  rdkafka,
  mongoc,
  cyrus_sasl,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "asapo-client";
  version = "25.03.0";
  src = fetchurl {
    url = "https://gitlab.desy.de/asapo/asapo/-/archive/${version}/asapo-${version}.tar.gz";
    hash = "sha256-DzqjHU4iqunrPTNV22D7FHZTBNzTh1A75qxfc2/VHBE=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    curl
    rdkafka
    mongoc
    cyrus_sasl
    python3
  ];

  cmakeFlags = [
    "-DBUILD_PYTHON=OFF"
    "-DBUILD_CLIENTS_ONLY=ON"
  ];

  preConfigure = ''
    export CI_COMMIT_REF_NAME=${version}
    export CI_COMMIT_TAG=${version}
  '';

  # The bundled rapidjson doesn't compile with gcc-14 and higher.
  postPatch = ''
    rm -r 3d_party/rapidjson/include/rapidjson
    cp -R ${rapidjson}/include 3d_party/rapidjson
  '';

  meta = with lib; {
    description = "Middleware platform for high-performance data analysis";
    homepage = "https://gitlab.desy.de/asapo/asapo";
    changelog = "https://gitlab.desy.de/asapo/asapo/-/blob/develop/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.linux;
  };

}
