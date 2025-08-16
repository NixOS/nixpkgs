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
  version ? "1.30.3",
}:

let
  hashes = {
    "1.30.3" = "sha256-3mzqsrbXfrtAAC5igIna5dAgU8FH23lkMS2IacVlCmI=";
    "2.0.1" = "sha256-4Arifb4Ms0PwjWzYphU0+ERQ8id1sRNBCWdR6P3v/Kc=";
  };
in
stdenv.mkDerivation rec {
  pname = "mongoc";
  inherit version;

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-c-driver";
    tag = version;
    hash = hashes.${version};
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
