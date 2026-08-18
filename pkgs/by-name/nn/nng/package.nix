{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  mbedtlsSupport ? true,
  mbedtls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nng";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-czfZYx4d8El6QOcvLhpBd82UpC4cDYI/HfYS2QOUezY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals mbedtlsSupport [ mbedtls ];

  buildInputs = lib.optionals mbedtlsSupport [ mbedtls ];

  cmakeFlags = [
    "-G Ninja"
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ]
  ++ lib.optionals mbedtlsSupport [
    "-DMBEDTLS_ROOT_DIR=${mbedtls}"
    "-DNNG_ENABLE_TLS=ON"
  ];

  meta = {
    homepage = "https://nng.nanomsg.org/";
    description = "Nanomsg next generation";
    license = lib.licenses.mit;
    mainProgram = "nngcat";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nviets ];
  };
})
