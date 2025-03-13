{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  zlib,
  zstd,
  icu,
  cyrus_sasl,
  snappy,
}:

stdenv.mkDerivation rec {
  pname = "mongoc";
  version = "1.30.1";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-c-driver";
    tag = version;
    hash = "sha256-jkMt6+nNV0fO8jp6L0ayed3MEWO56yQP7Rd1r7ccIrM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
    zstd
    icu
    cyrus_sasl
    snappy
  ];

  cmakeFlags = [
    "-DBUILD_VERSION=${version}"
    "-DENABLE_UNINSTALL=OFF"
    "-DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  # remove forbidden reference to $TMPDIR
  preFixup = ''
    rm -rf src/{libmongoc,libbson}
  '';

  meta = with lib; {
    description = "Official C client library for MongoDB";
    homepage = "http://mongoc.org";
    license = licenses.asl20;
    mainProgram = "mongoc-stat";
    maintainers = with maintainers; [ archer-65 ];
    platforms = platforms.all;
  };
}
