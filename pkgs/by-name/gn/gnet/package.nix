{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  autoconf,
  automake,
  glib,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnet";
  version = "2.0.8";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "Archive";
    repo = "gnet";
    rev = "GNET_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-B2H8s1JWNrvVR8qn6UFfAaCXQd0zEpNaLUPET99Ex7M=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
  ];
  buildInputs = [
    glib
    libtool
  ];

  preConfigure = "./autogen.sh";

  meta = {
    description = "Network library, written in C, object-oriented, and built upon GLib";
    homepage = "https://gitlab.gnome.org/Archive/gnet";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
