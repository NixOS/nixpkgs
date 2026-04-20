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

stdenv.mkDerivation (finalAttrs: {
  pname = "mongoc";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-c-driver";
    tag = finalAttrs.version;
    hash = "sha256-B9RjLAo8+4t5zKqrbGHBiNrFDzPX1pLG/7dLhSEl+yw=";
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
    "-DBUILD_VERSION=${finalAttrs.version}"
    "-DENABLE_UNINSTALL=OFF"
    "-DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  # remove forbidden reference to $TMPDIR
  preFixup = ''
    rm -rf src/{libmongoc,libbson}
  '';

  meta = {
    description = "Official C client library for MongoDB";
    homepage = "http://mongoc.org";
    license = lib.licenses.asl20;
    mainProgram = "mongoc-stat";
    maintainers = with lib.maintainers; [ archer-65 ];
    platforms = lib.platforms.all;
  };
})
