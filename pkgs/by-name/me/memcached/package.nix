{lib, stdenv, fetchurl, cyrus_sasl, libevent, nixosTests }:

stdenv.mkDerivation rec {
  version = "1.6.31";
  pname = "memcached";

  src = fetchurl {
    url = "https://memcached.org/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-INjTObj7H2x5zuIFWdxv+13+6E255Yn06yFPbSyHPvU=";
  };

  configureFlags = [
     "ac_cv_c_endian=${if stdenv.hostPlatform.isBigEndian then "big" else "little"}"
  ];

  buildInputs = [cyrus_sasl libevent];

  hardeningEnable = [ "pie" ];

  env.NIX_CFLAGS_COMPILE = toString ([ "-Wno-error=deprecated-declarations" ]
    ++ lib.optional stdenv.hostPlatform.isDarwin "-Wno-error");

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
