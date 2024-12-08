{ lib, stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "liblbfgs";
  version = "1.10";

  configureFlags = [ "--enable-sse2" ];
  src = fetchurl {
    url = "https://github.com/downloads/chokkan/liblbfgs/liblbfgs-${version}.tar.gz";
    sha256 = "1kv8d289rbz38wrpswx5dkhr2yh4fg4h6sszkp3fawxm09sann21";
  };

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Library of Limited-memory Broyden-Fletcher-Goldfarb-Shanno (L-BFGS)";
    homepage = "http://www.chokkan.org/software/liblbfgs/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
