{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  zstd,
  openssl,
  curl,
  cyrus_sasl,
  cmake,
  ninja,
  pkg-config,
  deterministic-host-uname,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rdkafka";
  version = "2.15.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "librdkafka";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WW64fwh0xR4lEVwmrv00tP9mo6b49aCNgLLH/P0YS8k=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    # cross: build system uses uname to determine host system
    deterministic-host-uname
  ];

  buildInputs = [
    zlib
    zstd
    openssl
    curl
    cyrus_sasl
  ];

  # examples and tests don't build on darwin statically
  cmakeFlags = [
    (lib.cmakeBool "RDKAFKA_BUILD_STATIC" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "RDKAFKA_BUILD_TESTS" (
      !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isStatic
    ))
    (lib.cmakeBool "RDKAFKA_BUILD_EXAMPLES" (
      !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isStatic
    ))
    (lib.cmakeFeature "CMAKE_C_FLAGS" "-Wno-error=strict-overflow")
  ];

  postPatch = ''
    patchShebangs .
  '';

  postFixup =
    # rdkafka changes the library names for static libraries but users in pkgsStatic aren't likely to be aware of this
    # make sure the libraries are findable with both names
    lib.optionalString stdenv.hostPlatform.isStatic ''
      for pc in rdkafka{,++}; do
        ln -s $dev/lib/pkgconfig/$pc{-static,}.pc
      done
    '';

  enableParallelBuilding = true;

  meta = {
    description = "Apache Kafka C/C++ client library";
    homepage = "https://github.com/confluentinc/librdkafka";
    changelog = "https://github.com/confluentinc/librdkafka/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ commandodev ];
  };
})
