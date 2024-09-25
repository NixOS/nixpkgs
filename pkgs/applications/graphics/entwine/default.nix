{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
, cmake
, pdal
, curl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "entwine";
  version = "unstable-2023-04-27";

  src = fetchFromGitHub {
    owner = "connormanning";
    repo = "entwine";
    rev = version;
    sha256 = "sha256-RlNxTtqxQoniI1Ugj5ot0weu7ji3WqDJZpMu2n8vBkw=";
  };

  buildInputs = [
    openssl
    pdal
    curl
  ];

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = gitUpdater {};

  meta = with lib; {
    description = "Point cloud organization for massive datasets";
    homepage = "https://entwine.io/";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.linux;
    mainProgram = "entwine";
  };
}
