{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  guile,
  pkg-config,
  texinfo,
  lzlib,
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

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  # tests fail on darwin
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "A GNU Guile library providing bindings to lzlib";
    homepage = "https://notabug.org/guile-lzlib/guile-lzlib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = guile.meta.platforms;
  };
}
