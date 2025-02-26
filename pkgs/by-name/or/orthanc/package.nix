{
  lib,
  stdenv,
  fetchzip,
  boost,
  civetweb,
  cmake,
  curl,
  dcmtk,
  gtest,
  jsoncpp,
  libjpeg,
  libpng,
  libuuid,
  log4cplus,
  lua,
  openssl,
  protobuf,
  pugixml,
  python3,
  sqlite,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orthanc";
  version = "1.12.6";

  src = fetchzip {
    url = "https://orthanc.uclouvain.be/downloads/sources/orthanc/Orthanc-${finalAttrs.version}.tar.gz";
    hash = "sha256-OwpmRMrdhUdve/nfUTPTQtHNqoOINV0mk2WfY6xp6Qs=";
  };

  sourceRoot = "${finalAttrs.src.name}/OrthancServer";

  nativeBuildInputs = [
    boost
    civetweb
    cmake
    curl
    dcmtk
    gtest
    jsoncpp
    libjpeg
    libpng
    libuuid
    log4cplus
    lua
    openssl
    protobuf
    pugixml
    python3
    sqlite.dev
    unzip
  ];

  cmakeFlags = [
    # Disable downloads during the build
    (lib.cmakeBool "BUILD_CONNECTIVITY_CHECKS" false)
    (lib.cmakeFeature "DCMTK_DICTIONARY_DIR_AUTO" "${dcmtk}")
  ];

})
