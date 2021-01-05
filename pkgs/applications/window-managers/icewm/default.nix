{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, perl
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
}:

stdenv.mkDerivation rec {
  pname = "icewm";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner  = "bbidulock";
    repo = pname;
    rev = version;
    sha256 = "sha256-WdRAWAQEf9c66MVrLAs5VgBDK5r4JKM2GrjAV4cuGfA=";
  };

  nativeBuildInputs = [ cmake pkg-config perl asciidoc ];

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

  meta = with stdenv.lib; {
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
    homepage = "https://www.ice-wm.org/";
    license = licenses.lgpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
