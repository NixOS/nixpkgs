{ lib, stdenv, fetchurl, libxcrypt }:

stdenv.mkDerivation rec {
  pname = "srelay";
  version = "0.4.8";

  src = fetchurl {
    url = "mirror://sourceforge/project/socks-relay/socks-relay/srelay-${version}/srelay-${version}.tar.gz";
    sha256 = "1sn6005aqyfvrlkm5445cyyaj6h6wfyskfncfmds55x34hfyxpvl";
  };

  patches = [ ./arm.patch ];

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
}
