{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  pkg-config,
  libfm-extra,
  autoreconfHook,
  gtk-doc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "menu-cache";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "menu-cache";
    tag = finalAttrs.version;
    hash = "sha256-5Vp2btrflimy+Hq+3MLpic/quZMJ3uwsMq12G7s4DGI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gtk-doc
  ];

  buildInputs = [
    glib
    libfm-extra
  ];

  meta = {
    description = "Library to read freedesktop.org menu files";
    homepage = "https://blog.lxde.org/tag/menu-cache/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.ttuegel ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
