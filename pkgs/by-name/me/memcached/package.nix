{
  lib,
  stdenv,
  fetchurl,
  cyrus_sasl,
  libevent,
  nixosTests,
}:

stdenv.mkDerivation rec {
  version = "1.6.39";
  pname = "memcached";

  src = fetchurl {
    url = "https://memcached.org/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-I+VQfpM7FUYxYdTF05IbDF80C1Qtbt1/bF4Xw08Ro2M=";
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

  meta = with lib; {
    description = "Distributed memory object caching system";
    homepage = "http://memcached.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.coconnor ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "memcached";
  };
  passthru.tests = {
    smoke-tests = nixosTests.memcached;
  };
}
