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

  meta = with lib; {
    homepage = "https://nng.nanomsg.org/";
    description = "Nanomsg next generation";
    license = licenses.mit;
    mainProgram = "nngcat";
    platforms = platforms.unix;
    maintainers = with maintainers; [ nviets ];
  };
}
