{ lib
, stdenv
, fetchFromGitHub
, cmake
, pdal
, curl
, openssl
}:

stdenv.mkDerivation {
  pname = "entwine";
  version = "unstable-2023-04-27";

  src = fetchFromGitHub {
    owner = "connormanning";
    repo = "entwine";
    rev = "8bd179c38e6da1688f42376b88ff30427672c4e3";
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

  meta = with lib; {
    description = "Point cloud organization for massive datasets";
    homepage = "https://entwine.io/";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.linux;
  };
}
