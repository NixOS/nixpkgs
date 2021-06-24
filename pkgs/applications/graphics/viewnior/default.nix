{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, desktop-file-utils, gtk2, libpng, exiv2, lcms
, intltool, gettext, shared-mime-info, glib, gdk-pixbuf, perl}:

stdenv.mkDerivation rec {
  pname = "viewnior";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "hellosiyan";
    repo = "Viewnior";
    rev = "${pname}-${version}";
    sha256 = "0y4hk3vq8psba5k615w18qj0kbdfp5w0lm98nv5apy6hmcpwfyig";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    intltool
    gettext
  ];

  buildInputs = [
    gtk2
    libpng
    exiv2
    lcms
    shared-mime-info
    glib
    gdk-pixbuf
    perl
  ];

  meta = with lib; {
    description = "Fast and simple image viewer";
    longDescription =
      '' Viewnior is insipred by big projects like Eye of Gnome, because of it's
         usability and richness,and by GPicView, because of it's lightweight design and
         minimal interface. So here comes Viewnior - small and light, with no compromise
         with the quality of it's functions. The program is made with better integration
         in mind (follows Gnome HIG2).
      '';
    license = licenses.gpl3;
    homepage = "http://siyanpanayotov.com/project/viewnior/";
    maintainers = with maintainers; [ smironov artturin ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
