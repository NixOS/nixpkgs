{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  bzip2,
  libxml2,
  libzip,
  boost,
  lua5_4,
  luabind,
  onetbb,
  expat,
  libarchive,
  fmt,
  rapidjson,
  sol2,
  flatbuffers,
  protozero,
  vtzero,
  libosmium,
  nixosTests,
}:

let
  lua = lua5_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "osrm-backend";
  version = "26.6.4";

  src = fetchFromGitHub {
    owner = "Project-OSRM";
    repo = "osrm-backend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-13Qwi/RNChWHoL4bbY2O3O73jYQZpzRJW4Omtp6t1SI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    bzip2
    libxml2
    libzip
    boost
    lua
    (luabind.override { inherit lua; })
    onetbb
    expat
    libarchive
    fmt
    rapidjson
    sol2
    flatbuffers
    protozero
    vtzero
    libosmium
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # # Needed with GCC 12
    # "-Wno-error=uninitialized"
    # # Needed with GCC 14
    # "-Wno-error=maybe-uninitialized"
  ];

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
    changelog = "https://github.com/Project-OSRM/osrm-backend/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ erictapen ];
    platforms = lib.platforms.unix;
  };
})
