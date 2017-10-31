{ stdenv, fetchFromGitHub, fetchpatch
, pkgconfig, which, perl, gtk2, xrandr
, cairo, dbus, gdk_pixbuf, glib, libX11, libXScrnSaver
, libXinerama, libnotify, libxdg_basedir, pango, xproto, librsvg
}:

stdenv.mkDerivation rec {
  name = "dunst-${version}";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "dunst-project";
    repo = "dunst";
    rev = "v${version}";
    sha256 = "0jncnb4z4hg92ws08bkf52jswsd4vqlzyznwbynhh2jh6q0sl18b";
  };

  nativeBuildInputs = [ perl pkgconfig which ];

  buildInputs = [
    cairo dbus gdk_pixbuf glib libX11 libXScrnSaver
    libXinerama libnotify libxdg_basedir pango xproto librsvg gtk2 xrandr
  ];

  outputs = [ "out" "man" ];

  makeFlags = [ "PREFIX=$(out)" "VERSION=$(version)" ];

  meta = with stdenv.lib; {
    description = "Lightweight and customizable notification daemon";
    homepage = http://www.knopwob.org/dunst/;
    license = licenses.bsd3;
    # NOTE: 'unix' or even 'all' COULD work too, I'm not sure
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
  };
}
