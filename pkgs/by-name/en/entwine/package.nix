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
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "connormanning";
    repo = "entwine";
    rev = version;
    hash = "sha256-K/mR3Js5F6JeS9xvEOhzX4sXGK/Zo+1mHCXDSaBdV2M=";
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

<<<<<<< HEAD
  meta = {
    description = "Point cloud organization for massive datasets";
    homepage = "https://entwine.io/";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Point cloud organization for massive datasets";
    homepage = "https://entwine.io/";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ matthewcroughan ];
    teams = [ teams.geospatial ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "entwine";
  };
}
