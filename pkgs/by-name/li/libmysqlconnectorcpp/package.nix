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
  version = "9.3.0";

  src = fetchurl {
    url = "mirror://mysql/Connector-C++/mysql-connector-c++-${version}-src.tar.gz";
    hash = "sha256-Jopvf0pstZ9T3eWWI74VWfkTop7B3oG/D/zL94DRtBY=";
  };

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
