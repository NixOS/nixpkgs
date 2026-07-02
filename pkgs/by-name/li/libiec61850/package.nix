{
  cmake,
  mbedtls,
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  withTls ? !stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libiec61850";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "mz-automation";
    repo = "libiec61850";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9UPXuZkAxr3SSjPN3VZRr6Hsz0GyDVJLUZEM+zZruik=";
  };

  separateDebugInfo = true;

  cmakeFlags = lib.optionals withTls [
    "-DCONFIG_USE_EXTERNAL_MBEDTLS_DYNLIB=ON"
    "-DCONFIG_EXTERNAL_MBEDTLS_DYNLIB_PATH=${mbedtls}/lib"
    "-DCONFIG_EXTERNAL_MBEDTLS_INCLUDE_PATH=${mbedtls}/include"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optionals withTls [ mbedtls ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Open-source library for the IEC 61850 protocols";
    homepage = "https://libiec61850.com/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      stv0g
      pjungkamp
    ];
    platforms = lib.platforms.unix;
  };
})
