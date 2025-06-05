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

stdenv.mkDerivation rec {
  pname = "menu-cache";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "menu-cache";
    tag = version;
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

  meta = with lib; {
    description = "Library to read freedesktop.org menu files";
    homepage = "https://blog.lxde.org/tag/menu-cache/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
