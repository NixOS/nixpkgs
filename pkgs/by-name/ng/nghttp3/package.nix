{
  lib,
  stdenv,
  fetchurl,
  cmake,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nghttp3";
  version = "1.19.0";

  src = fetchurl {
    url = "https://github.com/ngtcp2/nghttp3/releases/download/v${finalAttrs.version}/nghttp3-${finalAttrs.version}.tar.bz2";
    hash = "sha256-4RVyQwioub5Ooe7kmoZH9vJicbZh+r9Y2BQ78UII4LI=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ cmake ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_SHARED_LIB" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "ENABLE_STATIC_LIB" stdenv.hostPlatform.isStatic)
  ]
  ++ (lib.optional stdenv.hostPlatform.isWindows "-DENABLE_LIB_ONLY=1");

  doCheck = true;

  passthru.tests = {
    inherit curl;
  };

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/ngtcp2/nghttp3";
    changelog = "https://github.com/ngtcp2/nghttp3/releases/tag/v${finalAttrs.version}";
    description = "Implementation of HTTP/3 mapping over QUIC and QPACK in C";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ izorkin ];
  };
})
