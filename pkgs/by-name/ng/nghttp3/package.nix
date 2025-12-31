{
  lib,
  stdenv,
  fetchurl,
  cmake,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nghttp3";
  version = "1.13.1";

  src = fetchurl {
    url = "https://github.com/ngtcp2/nghttp3/releases/download/v${finalAttrs.version}/nghttp3-${finalAttrs.version}.tar.bz2";
    hash = "sha256-8lH+Vm4oIdz9BChVN15QsevqxfHKeUjQDiFWPFgiHiA=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_SHARED_LIB" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "ENABLE_STATIC_LIB" stdenv.hostPlatform.isStatic)
  ]
  # The examples (qpack) include Unix-only headers such as <arpa/inet.h>, which
  # do not exist on MinGW.  MSYS2 builds nghttp3 with ENABLE_LIB_ONLY=ON.
  ++ lib.optionals stdenv.hostPlatform.isMinGW [
    (lib.cmakeBool "ENABLE_LIB_ONLY" true)
  ];

  doCheck = !stdenv.hostPlatform.isMinGW;

  passthru.tests = {
    inherit curl;
  };

  meta = {
    homepage = "https://github.com/ngtcp2/nghttp3";
    changelog = "https://github.com/ngtcp2/nghttp3/releases/tag/v${finalAttrs.version}";
    description = "Implementation of HTTP/3 mapping over QUIC and QPACK in C";
    license = lib.licenses.mit;
    # MSYS2 ships nghttp3 for mingw-w64, and nixpkgs' MinGW curl depends on it.
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ izorkin ];
  };
})
