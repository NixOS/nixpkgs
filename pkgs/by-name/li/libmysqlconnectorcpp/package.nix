{ lib, stdenv
, fetchurl
, cmake
, boost
, openssl
, mysql80
}:

stdenv.mkDerivation rec {
  pname = "libmysqlconnectorcpp";
  version = "9.2.0";

  src = fetchurl {
    url = "mirror://mysql/Connector-C++/mysql-connector-c++-${version}-src.tar.gz";
    hash = "sha256-JJ6sLHfy5HgODWGxw/ZxrJPMbjfu58nLgWVZMOOjhDU=";
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
