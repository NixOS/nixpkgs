{
  lib,
  stdenv,
  fetchurl,
  guile,
  guile-fibers,
  guile-gcrypt,
  guile-gnutls,
  texinfo,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "guile-goblins";
  version = "0.13.0";

  src = fetchurl {
    url = "https://spritely.institute/files/releases/guile-goblins/guile-goblins-${version}.tar.gz";
    hash = "sha256-efmyOtPAz1ZPdMCuVaGALR6e0lg7gcjt81BUMBVUKug=";
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
  ];
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  # tests hang on darwin, and fail randomly on aarch64-linux on ofborg
  doCheck = !stdenv.isDarwin && !stdenv.isAarch64;

  meta = with lib; {
    description = "Spritely Goblins for Guile";
    homepage = "https://spritely.institute/goblins/";
    license = licenses.asl20;
    maintainers = with maintainers; [ offsetcyan ];
    platforms = guile.meta.platforms;
  };
}
