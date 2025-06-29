{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  bzip2,
  libxml2,
  libzip,
  boost,
  lua,
  luabind,
  tbb_2022,
  expat,
  nixosTests,
}:

let
  tbb = tbb_2022;
in
stdenv.mkDerivation rec {
  pname = "osrm-backend";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "Project-OSRM";
    repo = "osrm-backend";
    tag = "V${version}";
    hash = "sha256-R2Sx+DbT6gROI8X1fkxqOGbMqgmsnNiw2rUX6gSZuTs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    bzip2
    libxml2
    libzip
    boost
    lua
    luabind
    tbb
    expat
  ];

  # Needed with GCC 12
  env.NIX_CFLAGS_COMPILE = "-Wno-error=uninitialized";

  postInstall = ''
    mkdir -p $out/share/osrm-backend
    cp -r ../profiles $out/share/osrm-backend/profiles
  '';

  passthru.tests = {
    inherit (nixosTests) osrm-backend;
  };

  meta = {
    homepage = "https://project-osrm.org/";
    description = "Open Source Routing Machine computes shortest paths in a graph. It was designed to run well with map data from the Openstreetmap Project";
    changelog = "https://github.com/Project-OSRM/osrm-backend/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ erictapen ];
    platforms = lib.platforms.unix;
  };
}
