{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "LAStools";
  version = "2.0.3-unstable-2025-09-15";

  src = fetchFromGitHub {
    owner = "LAStools";
    repo = "LAStools";
    rev = "718f0032e14499a0fa54f6ecef483ab98a6da286";
    sha256 = "sha256-j8K6aB7uYWEQtefOj2gPGuplBY61SryKJtdFmoBBv9o=";
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

  meta = with lib; {
    description = "Software for rapid LiDAR processing";
    homepage = "http://lastools.org/";
    license = licenses.unfree;
    maintainers = with maintainers; [ stephenwithph ];
    teams = [ teams.geospatial ];
    platforms = platforms.unix;
  };
}
