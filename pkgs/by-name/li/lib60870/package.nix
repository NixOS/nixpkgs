{
  cmake,
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  mbedtls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lib60870";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "mz-automation";
    repo = "lib60870";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WXEe+G7ib9XNAZSsNl/RZcFHXpIbCMKNfPLnxZzz09E=";
  };

  sourceRoot = "${finalAttrs.src.name}/lib60870-C";

  postPatch = ''
    # Keep system mbedTLS support enabled without vendored mbedTLS sources.
    substituteInPlace CMakeLists.txt \
      --replace-fail "if(MBEDTLS_DIR)" "if(MBEDTLS_DIR OR WITH_MBEDTLS3)"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/CMakeLists.txt \
      --replace-warn "-lrt" ""
  '';

  separateDebugInfo = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ mbedtls ];

  cmakeFlags = [ (lib.cmakeBool "WITH_MBEDTLS3" true) ];

  env.NIX_LDFLAGS = "-lmbedcrypto -lmbedx509 -lmbedtls";

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Implementation of the IEC 60870-5-101/104 protocol";
    homepage = "https://libiec61850.com/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ stv0g ];
    platforms = lib.platforms.unix;
  };
})
