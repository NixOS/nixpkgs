{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  protobuf,
  protobufc,
  libsodium,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnats";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "nats.c";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-W1WxaQ33K+N3AHCK3sQWTQo4sN57qW2ZuAGrj6JpgCU=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libsodium
    openssl
    protobuf
    protobufc
  ];

  separateDebugInfo = true;
  outputs = [
    "out"
    "dev"
  ];

  # https://github.com/nats-io/nats.c/issues/542
  postPatch = ''
    substituteInPlace src/libnats.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  postFixup = ''
    substituteInPlace $dev/lib/cmake/cnats/cnats-config.cmake \
      --replace-fail "_IMPORT_PREFIX \"$out\"" "_IMPORT_PREFIX \"$dev\""
  '';

  meta = {
    description = "C API for the NATS messaging system";
    homepage = "https://github.com/nats-io/nats.c";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
})
