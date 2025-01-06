{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  zstd,
  pkg-config,
  python3,
  openssl,
  which,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rdkafka";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "librdkafka";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-qgy5VVB7H0FECtQR6HkTJ58vrHIU9TAFurDNuZGGgvw=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
    which
  ];

  buildInputs = [
    zlib
    zstd
    openssl
    curl
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  meta = {
    description = "librdkafka - Apache Kafka C/C++ client library";
    homepage = "https://github.com/confluentinc/librdkafka";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ commandodev ];
  };
})
