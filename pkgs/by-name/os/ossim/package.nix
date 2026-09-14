{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,

  cmake,
  curl,
  freetype,
  geos,
  jsoncpp,
  libgeotiff,
  libjpeg,
  libtiff,
  libuuid,
  proj,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ossim";
  version = "2.12.1-unstable-2026-07-24";

  src = fetchFromGitHub {
    owner = "ossimlabs";
    repo = "ossim";
    rev = "9efc0b6a21af7e0017fe2a40027026e9f887ed59";
    hash = "sha256-ExW1tpFe7LAKAj9JqZchJepP648hooF33ue0kDL+q+A=";
  };

  patches = [
    # Fix incorrect (non-"ossim/"-prefixed) includes that a few files use,
    # inconsistent with the rest of the tree, causing them to fail to find headers.
    # https://github.com/ossimlabs/ossim/pull/357
    ./fix-include-paths.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'GET_GIT_REVISION()' "" \
      --replace-fail 'OSSIM_GIT_REVISION_NUMBER "UNKNOWN"' 'OSSIM_GIT_REVISION_NUMBER "${finalAttrs.version}"'
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    curl
    freetype
    geos
    jsoncpp
    libgeotiff
    libjpeg
    libtiff
    libuuid
    proj
    sqlite
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_OSSIM_JSONCPP" false)
    (lib.cmakeBool "BUILD_OSSIM_TESTS" false)
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
  ];

  postInstall = ''
    for binary in $out/bin/ossim-*; do
      wrapProgram $binary \
        --prefix LD_LIBRARY_PATH ":" $out/lib
    done
  '';

  meta = {
    description = "Open Source Software Image Map library";
    homepage = "https://github.com/ossimlabs/ossim";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.unix;
  };
})
