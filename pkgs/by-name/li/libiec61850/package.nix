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
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "mz-automation";
    repo = "libiec61850";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KqgQxy/4vwFDkr9tVCVWDmbNuGivN6knf7rNHS+DTxc=";
  };

  separateDebugInfo = true;

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/CMakeLists.txt --replace-fail "-lrt" ""
    substituteInPlace hal/CMakeLists.txt --replace-fail "-lrt" ""
  '';

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
