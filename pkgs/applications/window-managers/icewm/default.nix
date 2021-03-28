{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, asciidoc
, expat
, fontconfig
, freetype
, fribidi
, gdk-pixbuf
, gdk-pixbuf-xlib
, gettext
, glib
, imlib2
, libICE
, libSM
, libX11
, libXcomposite
, libXdamage
, libXdmcp
, libXext
, libXfixes
, libXft
, libXinerama
, libXpm
, libXrandr
, libjpeg
, libpng
, libpthreadstubs
, libsndfile
, libtiff
, libungif
, libxcb
, mkfontdir
, pcre
, perl
}:

stdenv.mkDerivation rec {
  pname = "icewm";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner  = "bbidulock";
    repo = pname;
    rev = version;
    hash = "sha256-STM8t311lf0xIqs2Onmwg48xgE7V9VZrUfJrUzYRxL4=";
  };

  nativeBuildInputs = [
    asciidoc
    cmake
    perl
    pkg-config
  ];
  buildInputs = [
    expat
    fontconfig
    freetype
    fribidi
    gdk-pixbuf
    gdk-pixbuf-xlib
    gettext
    glib
    imlib2
    libICE
    libSM
    libX11
    libXcomposite
    libXdamage
    libXdmcp
    libXext
    libXfixes
    libXft
    libXinerama
    libXpm
    libXrandr
    libjpeg
    libpng
    libpthreadstubs
    libsndfile
    libtiff
    libungif
    libxcb
    mkfontdir
    pcre
  ];

  cmakeFlags = [ "-DPREFIX=$out" "-DCFGDIR=/etc/icewm" ];

  # install legacy themes
  postInstall = ''
    cp -r ../lib/themes/{gtk2,Natural,nice,nice2,warp3,warp4,yellowmotif} $out/share/icewm/themes/
  '';

  meta = with lib; {
    homepage = "https://www.ice-wm.org/";
    description = "A simple, lightweight X window manager";
    longDescription = ''
      IceWM is a window manager for the X Window System. The goal of IceWM is
      speed, simplicity, and not getting in the user’s way. It comes with a
      taskbar with pager, global and per-window keybindings and a dynamic menu
      system. Application windows can be managed by keyboard and mouse. Windows
      can be iconified to the taskbar, to the tray, to the desktop or be made
      hidden. They are controllable by a quick switch window (Alt+Tab) and in a
      window list. A handful of configurable focus models are
      menu-selectable. Setups with multiple monitors are supported by RandR and
      Xinerama. IceWM is very configurable, themeable and well documented. It
      includes an optional external background wallpaper manager with
      transparency support, a simple session manager and a system tray.
    '';
    license = licenses.lgpl2Only;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
