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
stdenv.mkDerivation rec {
  pname = "guile-goblins";
  version = "0.15.1";

  src = fetchurl {
    url = "https://spritely.institute/files/releases/guile-goblins/guile-goblins-${version}.tar.gz";
    hash = "sha256-2oPS6Ar0ee7BQBtjvhJCCQYXK2TLIiADiCwnDaHPGBc=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    guile
    pkg-config
    texinfo
  ];
  buildInputs = [
    guile
    guile-fibers
    guile-gcrypt
    guile-gnutls
    guile-websocket
  ];
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  # tests hang on darwin, and fail randomly on aarch64-linux on ofborg
  doCheck = !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isAarch64;

  meta = with lib; {
    description = "Spritely Goblins for Guile";
    homepage = "https://spritely.institute/goblins/";
    license = licenses.asl20;
    maintainers = with maintainers; [ offsetcyan ];
    platforms = guile.meta.platforms;
  };
}
