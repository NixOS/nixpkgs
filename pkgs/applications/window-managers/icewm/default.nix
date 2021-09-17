{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, asciidoc
, cmake
, expat
, fontconfig
, freetype
, fribidi
, gdk-pixbuf
, gdk-pixbuf-xlib
, gettext
, giflib
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
, libxcb
, mkfontdir
, pcre
, perl
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "icewm";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner  = "ice-wm";
    repo = pname;
    rev = version;
    hash = "sha256-R06tiWS9z6K5Nbi+vvk7DyozpcFdrHleMeh7Iq/FfHQ=";
  };

  patches = [
    # https://github.com/ice-wm/icewm/pull/57
    # Fix trailing -I that leads to "to generate dependencies you must specify either '-M' or '-MM'"
    (fetchpatch {
      url = "https://github.com/ice-wm/icewm/pull/57/commits/ebd2c45341cc31755758a423392a0f78a64d2d37.patch";
      sha256 = "16m9znd3ijcfl7la3l27ac3clx8l9qng3fprkpxqcifd89ny1ml5";
    })
  ];

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
    giflib
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
    libxcb
    mkfontdir
    pcre
  ];

  cmakeFlags = [
    "-DPREFIX=$out"
    "-DCFGDIR=/etc/icewm"
  ];

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
