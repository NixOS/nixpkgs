{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libbsd,
  microsoft-gsl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iqueue";
  version = "0.1.0";
  src = fetchurl {
    url = "https://github.com/twosigma/iqueue/releases/download/v${finalAttrs.version}/iqueue-${finalAttrs.version}.tar.gz";
    sha256 = "0049fnr02k15gr21adav33swrwxrpbananilnrp63vp5zs5v9m4x";
  };

  doCheck = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libbsd
    microsoft-gsl
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=array-parameter"
    "-Wno-error=misleading-indentation"
  ];

  meta = {
    homepage = "https://github.com/twosigma/iqueue";
    description = "Indexed queue";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
})
