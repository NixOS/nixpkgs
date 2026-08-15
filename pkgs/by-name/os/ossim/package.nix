{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  makeWrapper,
  curl,
  freetype,
  geos,
  jsoncpp,
  libgeotiff,
  libjpeg,
  libtiff,
  proj,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ossim";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "ossimlabs";
    repo = "ossim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nVQN+XnCYpVQSkgKsolqbR3KtPGTkvpym4cDl7IqjUc=";
  };

  patches = [
    # Fixed build error gcc version 15.0.1
    (fetchpatch {
      url = "https://github.com/ossimlabs/ossim/commit/13b9fa9ae54f79a7e7728408de6246e00d38f399.patch";
      hash = "sha256-AKzOT+JurB/54gvzn2a5amw+uIupaNxssnEhc8CSfPM=";
    })
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
    proj
    sqlite
  ];

  cmakeFlags = [
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
