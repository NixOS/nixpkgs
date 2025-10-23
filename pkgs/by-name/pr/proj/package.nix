{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  buildPackages,
  callPackage,
  sqlite,
  libtiff,
  curl,
  gtest,
  nlohmann_json,
  python3,
  cacert,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proj";
  version = "9.7.0";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "PROJ";
    rev = finalAttrs.version;
    hash = "sha256-Vdznj9WGuws1p+owDNHlVERjOM3fS1+RBtqe01q500E=";
  };

  patches = [
    # https://github.com/OSGeo/PROJ/pull/3252
    ./only-add-curl-for-static-builds.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    sqlite
    libtiff
    curl
    nlohmann_json
  ];

  nativeCheckInputs = [
    cacert
    gtest
  ];

  cmakeFlags = [
    "-DUSE_EXTERNAL_GTEST=ON"
    "-DRUN_NETWORK_DEPENDENT_TESTS=OFF"
    "-DNLOHMANN_JSON_ORIGIN=external"
    "-DEXE_SQLITE3=${buildPackages.sqlite}/bin/sqlite3"
  ];
  CXXFLAGS = [
    # GCC 13: error: 'int64_t' in namespace 'std' does not name a type
    "-include cstdint"
  ];

  preCheck =
    let
      libPathEnvVar = if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
    ''
      export HOME=$TMPDIR
      export TMP=$TMPDIR
      export ${libPathEnvVar}=$PWD/lib
    '';

  doCheck = true;

  passthru.tests = {
    python = python3.pkgs.pyproj;
    proj = callPackage ./tests.nix { proj = finalAttrs.finalPackage; };
  };

  meta = with lib; {
    changelog = "https://github.com/OSGeo/PROJ/blob/${finalAttrs.src.rev}/NEWS.md";
    description = "Cartographic Projections Library";
    homepage = "https://proj.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
    teams = [ teams.geospatial ];
    platforms = platforms.unix;
  };
})
