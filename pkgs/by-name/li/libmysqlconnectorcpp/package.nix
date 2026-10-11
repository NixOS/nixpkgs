{
  lib,
  stdenv,
  fetchurl,
  cmake,
  boost,
  openssl,
  mysql84,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmysqlconnectorcpp";
  version = "26.7.0";

  src = fetchurl {
    url = "mirror://mysql/Connector-C++/mysql-connector-c++-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-W4TQtmKtfVwOOsLG2cxwgGWUHv42UJf6lr3iSxYGsxk=";
  };

  postPatch = ''
    sed '/^cmake_minimum_required/Is/VERSION [0-9]\.[0-9]/VERSION 3.5/' \
      -i ./cdk/extra/protobuf/CMakeLists.txt \
      -i ./cdk/extra/lz4/CMakeLists.txt \
      -i ./cdk/extra/zstd/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    mysql84.connector-c
  ];

  buildInputs = [
    boost
    openssl
    mysql84.connector-c
  ];

  strictDeps = true;

  cmakeFlags = [
    # libmysqlclient is shared library
    "-DMYSQLCLIENT_STATIC_LINKING=false"
    # still needed for mysql-workbench
    "-DWITH_JDBC=true"
  ];

  meta = {
    homepage = "https://dev.mysql.com/downloads/connector/cpp/";
    description = "C++ library for connecting to mysql servers";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
})
