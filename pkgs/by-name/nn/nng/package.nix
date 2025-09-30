{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  mbedtlsSupport ? true,
  mbedtls,
}:

stdenv.mkDerivation rec {
  pname = "nng";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nng";
    rev = "v${version}";
    hash = "sha256-yH/iK/DuVff2qby/wk6jJ9Tsmxrl9eMrb9bOxCzvmdA=";
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

  meta = with lib; {
    homepage = "https://nng.nanomsg.org/";
    description = "Nanomsg next generation";
    license = licenses.mit;
    mainProgram = "nngcat";
    platforms = platforms.unix;
    maintainers = with maintainers; [ nviets ];
  };
}
