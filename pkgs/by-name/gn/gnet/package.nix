{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoconf,
  automake,
  glib,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "gnet";
  version = "2.0.8";
  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "gnet";
    rev = "GNET_${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "1cy78kglzi235md964ikvm0rg801bx0yk9ya8zavndjnaarzqq87";
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
    homepage = "https://developer.gnome.org/gnet/";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
  };
}
