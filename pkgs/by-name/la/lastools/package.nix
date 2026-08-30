{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lastools";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "LAStools";
    repo = "LAStools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eXBrx8gKagxp1J4BOX+f2cH0GkMX0GJ8ebVZw7qqioA=";
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
    maintainers = with lib.maintainers; [ stephenwithph ];
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.unix;
  };
})
