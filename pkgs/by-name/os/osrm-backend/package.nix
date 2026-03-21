{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  pkg-config,
  bzip2,
  libxml2,
  libzip,
  boost,
  lua,
  luabind,
  onetbb,
  expat,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osrm-backend";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "Project-OSRM";
    repo = "osrm-backend";
    tag = "V${finalAttrs.version}";
    hash = "sha256-R2Sx+DbT6gROI8X1fkxqOGbMqgmsnNiw2rUX6gSZuTs=";
  };

  patches = [
    (fetchpatch2 {
      name = "Fix-build-with-Boost-1.89.0.patch";
      url = "https://github.com/Project-OSRM/osrm-backend/commit/a2e159d0d4f6b3922ee0cb058a800230cf90642e.patch?full_index=1";
      hash = "sha256-c+4Ll660jHLnFolehCpZQLca4pmyVsBfjwSY1BHBh40=";
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
    homepage = "https://project-osrm.org/";
    description = "Open Source Routing Machine computes shortest paths in a graph. It was designed to run well with map data from the Openstreetmap Project";
    changelog = "https://github.com/Project-OSRM/osrm-backend/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ erictapen ];
    platforms = lib.platforms.unix;
  };
})
