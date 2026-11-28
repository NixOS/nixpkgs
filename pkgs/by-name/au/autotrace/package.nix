{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  gettext,
  intltool,
  pkg-config,
  glib,
  imagemagick,
  libpng,
  pstoedit,
}:

stdenv.mkDerivation rec {
  pname = "autotrace";
  version = "0.31.13";

  src = fetchFromGitHub {
    owner = "autotrace";
    repo = "autotrace";
    tag = version;
    hash = "sha256-wqfvJhN0sx6ZK+6BeMgvaYdYlXC/p9DmlPZZgYOQIuY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    intltool
    pkg-config
  ];

  buildInputs = [
    glib
    imagemagick
    libpng
    pstoedit
  ];

  meta = {
    homepage = "https://github.com/autotrace/autotrace";
    description = "Utility for converting bitmap into vector graphics";
    platforms = lib.platforms.unix;
    maintainers = [ ];
    license = lib.licenses.gpl2;
    mainProgram = "autotrace";
  };
}
