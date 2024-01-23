{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, expat
, flac
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
, libogg
, libpng
, libpthreadstubs
, libsndfile
, libtiff
, libxcb
, mkfontdir
, pcre2
, perl
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icewm";
  version = "3.4.5";

  src = fetchFromGitHub {
    owner = "ice-wm";
    repo = "icewm";
    rev = finalAttrs.version;
    hash = "sha256-Auuu+hRYVziAF3hXH7XSOyNlDehEKg6QmSJicY+XQLk=";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ];

  buildInputs = [
    expat
    flac
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
    libogg
    libpng
    libpthreadstubs
    libsndfile
    libtiff
    libxcb
    mkfontdir
    pcre2
  ];

  cmakeFlags = [
    "-DPREFIX=$out"
    "-DCFGDIR=/etc/icewm"
  ];

  # install legacy themes
  postInstall = ''
    cp -r ../lib/themes/{gtk2,Natural,nice,nice2,warp3,warp4,yellowmotif} \
      $out/share/icewm/themes/
  '';

  meta = with lib; {
    homepage = "https://ice-wm.org/";
    description = "A simple, lightweight X window manager";
    longDescription = ''
      IceWM is a window manager for the X Window System. The goal of IceWM is
      speed, simplicity, and not getting in the user’s way. It comes with a
      taskbar with pager, global and per-window keybindings and a dynamic menu
      system. Application windows can be managed by keyboard and mouse. Windows
      can be iconified to the taskbar, to the tray, to the desktop or be made
      hidden. They are controllable by a quick switch window (Alt+Tab) and in a
      window list. A handful of configurable focus models are menu-selectable.
      Setups with multiple monitors are supported by RandR and Xinerama. IceWM
      is very configurable, themeable and well documented. It includes an
      optional external background wallpaper manager with transparency support,
      a simple session manager and a system tray.
    '';
    license = licenses.lgpl2Only;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
})
