{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "LAStools";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "LAStools";
    repo = "LAStools";
    rev = "v${version}";
    sha256 = "sha256-IyZjM8YvIVB0VPNuEhmHHw7EuKw5RanB2qhCnBD1fRY=";
  };

  patches = [
    ./drop-64-suffix.patch # necessary to prevent '64' from being appended to the names of the executables
  ];

  hardeningDisable = [
    "format"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isAarch64 "-Wno-narrowing";

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Software for rapid LiDAR processing";
    homepage = "http://lastools.org/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; lib.teams.geospatial.members ++ [ stephenwithph ];
    platforms = lib.platforms.unix;
  };
}
