{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  curl,
  curlpp,
  inih,
  openssl,
  pugixml,
  nlohmann_json,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minio-cpp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio-cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JKC9SYgb5+nQ3M5C6j6QLfltM+U18oaFrep4gOKPlCI=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'find_package(unofficial-curlpp CONFIG REQUIRED)' \
        'find_package(PkgConfig REQUIRED)
    pkg_check_modules(CURLPP REQUIRED IMPORTED_TARGET curlpp)' \
      --replace-fail \
        'unofficial::curlpp::curlpp' \
        'PkgConfig::CURLPP' \
      --replace-fail \
        'find_package(unofficial-inih CONFIG REQUIRED)' \
        'pkg_check_modules(INIH REQUIRED IMPORTED_TARGET INIReader)' \
      --replace-fail \
        'unofficial::inih::inireader' \
        'PkgConfig::INIH'

    substituteInPlace miniocpp-config.cmake.in \
      --replace-fail \
        'find_package(unofficial-curlpp CONFIG REQUIRED)' \
        'find_package(PkgConfig REQUIRED)
    pkg_check_modules(CURLPP REQUIRED IMPORTED_TARGET curlpp)' \
      --replace-fail \
        'find_package(unofficial-inih CONFIG REQUIRED)' \
        'pkg_check_modules(INIH REQUIRED IMPORTED_TARGET INIReader)'

    substituteInPlace miniocpp.pc.in \
      --replace-fail \
        'libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@' \
        'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail \
        'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' \
        'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    curl
    curlpp
    inih
    nlohmann_json
    openssl
    pugixml
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "MINIO_CPP_TEST" false)
    (lib.cmakeBool "MINIO_CPP_MAKE_DOC" false)
  ];

  meta = {
    description = "MinIO C++ Client SDK for Amazon S3 Compatible Cloud Storage";
    homepage = "https://github.com/minio/minio-cpp";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      cyrusknopf
      drupol
      roquess
    ];
  };
})
