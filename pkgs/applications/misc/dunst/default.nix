{ stdenv, fetchFromGitHub, fetchpatch
, pkgconfig, which, perl
, cairo, dbus, freetype, gdk_pixbuf, glib, libX11, libXScrnSaver
, libXext, libXinerama, libnotify, libxdg_basedir, pango, xproto
, librsvg
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

  patches = [(fetchpatch {
    name = "add-svg-support.patch";
    url = "https://github.com/knopwob/dunst/commit/63b11141185d1d07a6d12212257a543e182d250a.patch";
    sha256 = "0giiaj5zjim7xqcav5ij5gn4x6nnchkllwcx0ln16j0p3vbi4y4x";
  })];

  nativeBuildInputs = [ perl pkgconfig which ];

  buildInputs = [
    cairo dbus freetype gdk_pixbuf glib libX11 libXScrnSaver libXext
    libXinerama libnotify libxdg_basedir pango xproto librsvg
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
