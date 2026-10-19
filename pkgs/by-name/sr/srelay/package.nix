{
  lib,
  stdenv,
  fetchurl,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "srelay";
  version = "0.4.8";

  src = fetchurl {
    url = "mirror://sourceforge/project/socks-relay/socks-relay/srelay-${finalAttrs.version}/srelay-${finalAttrs.version}.tar.gz";
    hash = "sha256-dN/uHSSjl6Jbdcy6qb3jBhqpvGeFkFInzdt5rAoAxuo=";
  };

  patches = [
    ./arm.patch
    ./signal-handler.patch
  ];

  buildInputs = [ libxcrypt ];

  installPhase = "install -D srelay $out/bin/srelay";

  meta = {
    description = "SOCKS proxy and relay";
    homepage = "http://socks-relay.sourceforge.net/";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
    mainProgram = "srelay";
  };
})
