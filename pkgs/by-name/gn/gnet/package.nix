{
  lib,
  stdenv,
<<<<<<< HEAD
  fetchFromGitLab,
=======
  fetchFromGitHub,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pkg-config,
  autoconf,
  automake,
  glib,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "gnet";
  version = "2.0.8";
<<<<<<< HEAD

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "Archive";
    repo = "gnet";
    rev = "GNET_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-B2H8s1JWNrvVR8qn6UFfAaCXQd0zEpNaLUPET99Ex7M=";
=======
  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "gnet";
    rev = "GNET_${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "1cy78kglzi235md964ikvm0rg801bx0yk9ya8zavndjnaarzqq87";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Network library, written in C, object-oriented, and built upon GLib";
    homepage = "https://gitlab.gnome.org/Archive/gnet";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
=======
  meta = with lib; {
    description = "Network library, written in C, object-oriented, and built upon GLib";
    homepage = "https://developer.gnome.org/gnet/";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
