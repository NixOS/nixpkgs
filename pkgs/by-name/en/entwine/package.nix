{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  gtest,
  nlohmann_json,
  pdal,
  curl,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "entwine";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "connormanning";
    repo = "entwine";
    rev = version;
    hash = "sha256-RpUV75Dlyd3wTWGC3btpAFSjqpgK9zLXTl670Oh0Z2o=";
  };

  buildInputs = [
    gtest
    nlohmann_json
    openssl
    pdal
    curl
  ];

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Point cloud organization for massive datasets";
    homepage = "https://entwine.io/";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ matthewcroughan ];
    teams = [ teams.geospatial ];
    platforms = platforms.linux;
    mainProgram = "entwine";
  };
}
