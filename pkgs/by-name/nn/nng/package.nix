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
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nng";
    rev = "v${version}";
    hash = "sha256-N1ZMILrFhdkwU4PK/zlSCgGjOm0748fgvZRrk7I9YVg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ] ++ lib.optionals mbedtlsSupport [ mbedtls ];

  buildInputs = lib.optionals mbedtlsSupport [ mbedtls ];

  cmakeFlags =
    [ "-G Ninja" ]
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
}
