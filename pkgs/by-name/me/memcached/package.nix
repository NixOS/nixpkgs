{
  lib,
  stdenv,
  fetchurl,
  cyrus_sasl,
  libevent,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.6.41";
  pname = "memcached";

  src = fetchurl {
    url = "https://memcached.org/files/memcached-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-4JcHPBVu7/nhJlWwVPRG1XN0z7pcEy3Nvn+sZOcoKGo=";
  };

  configureFlags = [
    "ac_cv_c_endian=${if stdenv.hostPlatform.isBigEndian then "big" else "little"}"
  ];

  buildInputs = [
    cyrus_sasl
    libevent
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    [ "-Wno-error=deprecated-declarations" ] ++ lib.optional stdenv.hostPlatform.isDarwin "-Wno-error"
  );

  meta = {
    description = "Distributed memory object caching system";
    homepage = "http://memcached.org/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.coconnor ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "memcached";
  };
  passthru.tests = {
    smoke-tests = nixosTests.memcached;
  };
})
