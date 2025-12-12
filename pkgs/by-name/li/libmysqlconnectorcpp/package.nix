{
  lib,
  stdenv,
  fetchurl,
  cmake,
  boost,
  openssl,
  mysql80,
}:

stdenv.mkDerivation rec {
  pname = "libmysqlconnectorcpp";
  version = "9.4.0";

  src = fetchurl {
    url = "mirror://mysql/Connector-C++/mysql-connector-c++-${version}-src.tar.gz";
    hash = "sha256-NqfJPUoQ0doqLmY2dVnZF0GqDwNivArpQxcc8XcfZhU=";
  };

  postPatch = ''
    sed '/^cmake_minimum_required/Is/VERSION [0-9]\.[0-9]/VERSION 3.5/' \
      -i ./cdk/extra/protobuf/CMakeLists.txt \
      -i ./cdk/extra/lz4/CMakeLists.txt \
      -i ./cdk/extra/zstd/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    mysql80
  ];

  buildInputs = [
    boost
    openssl
    mysql80
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
}
