{ lib
, stdenv
, fetchurl
, guile
, guile-fibers
, guile-gcrypt
, texinfo
, pkg-config
}:
stdenv.mkDerivation rec {
  pname = "guile-goblins";
  version = "0.11.0";

  src = fetchurl {
    url = "https://spritely.institute/files/releases/guile-goblins/guile-goblins-${version}.tar.gz";
    hash = "sha256-1FD35xvayqC04oPdgts08DJl6PVnhc9K/Dr+NYtxhMU=";
  };

  strictDeps = true;
  nativeBuildInputs = [ guile pkg-config texinfo ];
  buildInputs = [ guile guile-fibers guile-gcrypt ];
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
