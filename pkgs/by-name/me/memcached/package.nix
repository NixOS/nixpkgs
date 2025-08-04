{
  lib,
  stdenv,
  fetchurl,
  cyrus_sasl,
  libevent,
  nixosTests,
}:

stdenv.mkDerivation rec {
  version = "1.6.38";
  pname = "memcached";

  src = fetchurl {
    url = "https://memcached.org/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-M015IpTjdzh5a1sDN1xHu22yg7EVLi6kzLcgFS3RfGY=";
  };

  configureFlags = [
    "ac_cv_c_endian=${if stdenv.hostPlatform.isBigEndian then "big" else "little"}"
  ];

  buildInputs = [
    cyrus_sasl
    libevent
  ];

  hardeningEnable = [ "pie" ];

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
}
