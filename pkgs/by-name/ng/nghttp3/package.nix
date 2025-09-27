{
  lib,
  stdenv,
  fetchurl,
  cmake,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nghttp3";
  version = "1.11.0";

  src = fetchurl {
    url = "https://github.com/ngtcp2/nghttp3/releases/download/v${finalAttrs.version}/nghttp3-${finalAttrs.version}.tar.bz2";
    hash = "sha256-AAKlyoVtsFmqbcac9zL7sA2aHnPteISPXUjyYh8gyoo=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags =
    if stdenv.hostPlatform.isStatic then
      [
        (lib.cmakeBool "ENABLE_SHARED_LIB" false)
        (lib.cmakeBool "ENABLE_STATIC_LIB" true)
      ]
    else
      [
        (lib.cmakeBool "ENABLE_STATIC_LIB" false)
      ];

  doCheck = true;

  passthru.tests = {
    inherit curl;
  };

  meta = {
    homepage = "https://github.com/ngtcp2/nghttp3";
    changelog = "https://github.com/ngtcp2/nghttp3/releases/tag/v${finalAttrs.version}";
    description = "Implementation of HTTP/3 mapping over QUIC and QPACK in C";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ izorkin ];
  };
})
