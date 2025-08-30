{
  lib,
  stdenv,
  autoconf,
  automake,
  autoreconfHook,
  fetchFromGitHub,
  glib,
  gtk-doc,
  pkg-config,
  libfm-extra,
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

  preAutoreconf = "./autogen.sh";

  nativeBuildInputs = [
    autoreconfHook
    autoconf
    automake
    gtk-doc
    pkg-config
  ];

  buildInputs = [
    glib
    libfm-extra
  ];

  meta = {
    description = "Library to read freedesktop.org menu files";
    homepage = "https://github.com/lxde/menu-cache";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.ttuegel ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
