{
  cmake,
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  mbedtls_2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lib60870";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "mz-automation";
    repo = "lib60870";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TjphTBBGjzbevUR0N1GHK/nic1pAdjWeiqxEMLozQOc=";
  };

  sourceRoot = "${finalAttrs.src.name}/lib60870-C";

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/CMakeLists.txt --replace-warn "-lrt" ""
  '';

  separateDebugInfo = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ mbedtls_2 ];

  cmakeFlags = [ (lib.cmakeBool "WITH_MBEDTLS" true) ];

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
