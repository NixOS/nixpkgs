{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "liblbfgs";
  version = "1.10";

  configureFlags = [ "--enable-sse2" ];
  src = fetchurl {
    url = "https://github.com/downloads/chokkan/liblbfgs/liblbfgs-${finalAttrs.version}.tar.gz";
    sha256 = "1kv8d289rbz38wrpswx5dkhr2yh4fg4h6sszkp3fawxm09sann21";
  };

  meta = {
    # last successful hydra build on darwin was in 2024
    broken =
      (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) || stdenv.hostPlatform.isDarwin;
    description = "Library of Limited-memory Broyden-Fletcher-Goldfarb-Shanno (L-BFGS)";
    homepage = "http://www.chokkan.org/software/liblbfgs/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
