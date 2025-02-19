{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pdal,
  curl,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "entwine";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "connormanning";
    repo = "entwine";
    rev = version;
    sha256 = "sha256-1dy5NafKX0E4MwFIggnr7bQIeB1KvqnNaQQUUAs6Bq8=";
  };

  buildInputs = [
    openssl
    pdal
    curl
  ];

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Point cloud organization for massive datasets";
    homepage = "https://entwine.io/";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; teams.geospatial.members ++ [ matthewcroughan ];
    platforms = platforms.linux;
    mainProgram = "entwine";
  };
}
