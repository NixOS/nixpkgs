{
  lib,
  stdenv,
  fetchurl,
  guile,
  guile-fibers,
  guile-gcrypt,
  guile-gnutls,
  guile-websocket,
  texinfo,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "guile-goblins";
  version = "0.17.0";

  src = fetchurl {
    url = "https://spritely.institute/files/releases/guile-goblins/guile-goblins-${finalAttrs.version}.tar.gz";
    hash = "sha256-IFZEB/HbBx1EDAO8+0xB/UB3iyogyzKbE+pbfbWrU5o=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    guile
    pkg-config
    texinfo
  ];
  buildInputs = [
    guile
  ];
  propagatedBuildInputs = [
    guile-fibers
    guile-gcrypt
    guile-gnutls
    guile-websocket
  ];
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  # tests hang on darwin, and fail randomly on aarch64-linux on ofborg
  doCheck = !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isAarch64;

  meta = {
    description = "Spritely Goblins for Guile";
    homepage = "https://spritely.institute/goblins/";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = guile.meta.platforms;
  };
})
