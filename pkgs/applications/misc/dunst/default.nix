{ stdenv, fetchFromGitHub
, pkgconfig, which, perl
, cairo, dbus, freetype, gdk_pixbuf, glib, libX11, libXScrnSaver
, libXext, libXinerama, libnotify, libxdg_basedir, pango, xproto
}:

stdenv.mkDerivation rec {
  name = "dunst-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "knopwob";
    repo = "dunst";
    rev = "v${version}";
    sha256 = "102s0rkcdz22hnacsi3dhm7kj3lsw9gnikmh3a7wk862nkvvwjmk";
  };

  nativeBuildInputs = [ perl pkgconfig which ];

  buildInputs = [
    cairo dbus freetype gdk_pixbuf glib libX11 libXScrnSaver libXext
    libXinerama libnotify libxdg_basedir pango xproto
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
