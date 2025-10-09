{
  lib,
  stdenv,
  fetchhg,
  boost,
  charls,
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
  versionCheckHook,
  nixosTests,
  orthanc-framework,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orthanc";
  version = "1.12.9";

  src = fetchhg {
    url = "https://orthanc.uclouvain.be/hg/orthanc/";
    rev = "Orthanc-${finalAttrs.version}";
    hash = "sha256-IBULO03og+aXmpYAXZdsesTFkc7HkeXol+A7yzDzcfQ=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  sourceRoot = "${finalAttrs.src.name}/OrthancServer";

  nativeBuildInputs = [
    cmake
    protobuf
    python3
    unzip
  ];

  buildInputs = [
    protobuf
    boost
    charls
    civetweb
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
    pugixml
    sqlite
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeFeature "DCMTK_DICTIONARY_DIR_AUTO" "${dcmtk}/share/dcmtk-${dcmtk.version}")
    (lib.cmakeFeature "DCMTK_LIBRARIES" "dcmjpls;oflog;ofstd")
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")

    (lib.cmakeBool "BUILD_CONNECTIVITY_CHECKS" false)
    (lib.cmakeBool "UNIT_TESTS_WITH_HTTP_CONNEXIONS" false)
    (lib.cmakeBool "STANDALONE_BUILD" true)
    (lib.cmakeBool "USE_SYSTEM_BOOST" true)
    (lib.cmakeBool "USE_SYSTEM_CIVETWEB" true)
    (lib.cmakeBool "USE_SYSTEM_DCMTK" true)
    (lib.cmakeBool "USE_SYSTEM_GOOGLE_TEST" true)
    (lib.cmakeBool "USE_SYSTEM_JSONCPP" true)
    (lib.cmakeBool "USE_SYSTEM_LIBICONV" true)
    (lib.cmakeBool "USE_SYSTEM_LIBJPEG" true)
    (lib.cmakeBool "USE_SYSTEM_LIBPNG" true)
    (lib.cmakeBool "USE_SYSTEM_LUA" true)
    (lib.cmakeBool "USE_SYSTEM_OPENSSL" true)
    (lib.cmakeBool "USE_SYSTEM_PROTOBUF" true)
    (lib.cmakeBool "USE_SYSTEM_PUGIXML" true)
    (lib.cmakeBool "USE_SYSTEM_SQLITE" true)
    (lib.cmakeBool "USE_SYSTEM_UUID" true)
    (lib.cmakeBool "USE_SYSTEM_ZLIB" true)
  ];

  # Remove warnings during the build
  env.NIX_CFLAGS_COMPILE = "-Wno-builtin-macro-redefined";

  postInstall = ''
    mkdir -p $doc/share/doc/orthanc
    cp -r $src/OrthancServer/Resources/Samples $doc/share/doc/orthanc/Samples
    cp -r $src/OrthancServer/Plugins/Samples $doc/share/doc/orthanc/OrthancPluginSamples
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    framework = orthanc-framework;
    tests = {
      inherit (nixosTests) orthanc;
    };
  };

  meta = {
    description = "Lightweight, RESTful DICOM server for healthcare and medical research";
    homepage = "https://www.orthanc-server.com/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Orthanc";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
