{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  zstd,
  openssl,
  curl,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rdkafka";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "librdkafka";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-OCCsxgEO8UvCcC0XwzqpqmaT8dV0Klrspp+2o1FbH2Y=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    zlib
    zstd
    openssl
    curl
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
    description = "librdkafka - Apache Kafka C/C++ client library";
    homepage = "https://github.com/confluentinc/librdkafka";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ commandodev ];
  };
})
