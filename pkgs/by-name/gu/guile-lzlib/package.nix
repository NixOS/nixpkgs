{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  guile,
  pkg-config,
  texinfo,
  lzlib,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "guile-lzlib";
  version = "0.3.0";

  src = fetchurl {
    url = "https://notabug.org/guile-lzlib/guile-lzlib/archive/${version}.tar.gz";
    hash = "sha256-p/mcjSoUPgXqItstyLnObCfK6UIWK0XuMBXtkCevD/I=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];
  propagatedBuildInputs = [
    guile
    lzlib
  ];

  patches = [
    # fix support for gcc14
    (fetchpatch {
      url = "https://notabug.org/guile-lzlib/guile-lzlib/commit/3fd524d1f0e0b9beeca53c514620b970a762e3da.patch";
      hash = "sha256-I1SSdygNixjx5LL/UPOgEGLILWWYKKfOGoCvXM5Sp/E=";
    })
  ];

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  # tests fail on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "GNU Guile library providing bindings to lzlib";
    homepage = "https://notabug.org/guile-lzlib/guile-lzlib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = guile.meta.platforms;
  };
}
