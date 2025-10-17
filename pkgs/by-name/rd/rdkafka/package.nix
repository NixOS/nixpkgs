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
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "librdkafka";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Hg0l44wFQSk8x14V4CxJN80aGrhaj3CIFOYBfNUbG3E=";
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

  postFixup = lib.optionalString stdenv.hostPlatform.isStatic ''
    # rdkafka changes the library names for static libraries but users in pkgsStatic aren't likely to be aware of this
    # make sure the libraries are findable with both names
    for pc in rdkafka{,++}; do
      ln -s $dev/lib/pkgconfig/$pc{-static,}.pc
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Apache Kafka C/C++ client library";
    homepage = "https://github.com/confluentinc/librdkafka";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ commandodev ];
  };
})
