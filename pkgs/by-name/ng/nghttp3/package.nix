{
  lib,
  stdenv,
  fetchurl,
  cmake,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nghttp3";
  version = "1.14.0";

  src = fetchurl {
    url = "https://github.com/ngtcp2/nghttp3/releases/download/v${finalAttrs.version}/nghttp3-${finalAttrs.version}.tar.bz2";
    hash = "sha256-JUi0zz3Bl6hB30/rBv1jfRlx4dahu+ES3KLsYYqz6UU=";
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
  ++ (lib.optional stdenv.hostPlatform.isWindows "-DENABLE_LIB_ONLY=1");

  doCheck = true;

  passthru.tests = {
    inherit curl;
  };

  meta = {
    homepage = "https://github.com/ngtcp2/nghttp3";
    changelog = "https://github.com/ngtcp2/nghttp3/releases/tag/v${finalAttrs.version}";
    description = "Implementation of HTTP/3 mapping over QUIC and QPACK in C";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ izorkin ];
  };
})
