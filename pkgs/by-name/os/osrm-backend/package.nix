{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  bzip2,
  libxml2,
  libzip,
  boost,
  lua5_2_compat,
  luabind,
  onetbb,
  expat,
  nixosTests,
}:
let
  lua = lua5_2_compat;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "osrm-backend";
  version = "26.4.0";

  src = fetchFromGitHub {
    owner = "Project-OSRM";
    repo = "osrm-backend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DV0oy++PrOwbybFEFRWnNxGfYshgsqDaHrHuVoTlIXE=";
  };

  patches = [
    # Fix compilation with gcc 16
    # https://github.com/Project-OSRM/osrm-backend/issues/7588
    (fetchpatch {
      url = "https://github.com/Project-OSRM/osrm-backend/commit/ada63647a7de9715a63a07e0840cf15aa2dc2944.patch";
      hash = "sha256-N0NaDQwR689YEYlLeSByM16QyJ7OIpmu2ky+WI6gWSs=";
    })
  ];

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
    onetbb
    expat
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=uninitialized"
    # Needed with GCC 14
    "-Wno-error=maybe-uninitialized"
  ];

  postInstall = ''
    mkdir -p $out/share/osrm-backend
    cp -r ../profiles $out/share/osrm-backend/profiles
  '';

  passthru.tests = {
    inherit (nixosTests) osrm-backend;
  };

  meta = {
    # last successful hydra build on darwin was in 2024
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://project-osrm.org/";
    description = "Open Source Routing Machine computes shortest paths in a graph. It was designed to run well with map data from the Openstreetmap Project";
    changelog = "https://github.com/Project-OSRM/osrm-backend/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ erictapen ];
    platforms = lib.platforms.unix;
  };
})
