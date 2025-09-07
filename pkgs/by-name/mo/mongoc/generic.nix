{
  version,
  hash,
}:
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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mongoc";
  inherit version;

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-c-driver";
    tag = finalAttrs.version;
    inherit hash;
  };

  __structuredAttrs = true;
  strictDeps = true;

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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Official C client library for MongoDB";
    homepage = "http://mongoc.org";
    license = lib.licenses.asl20;
    mainProgram = "mongoc-stat";
    maintainers = with lib.maintainers; [ archer-65 ];
    platforms = lib.platforms.all;
  };
})
