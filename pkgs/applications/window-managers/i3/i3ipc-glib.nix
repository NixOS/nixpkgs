{ stdenv, fetchFromGitHub, pkgconfig, xorgproto, libxcb
, autoreconfHook, json-glib, gtk-doc, which
, gobject-introspection
}:

stdenv.mkDerivation rec {

  name = "i3ipc-glib-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "i3ipc-glib";
    rev = "v${version}";
    sha256 = "1gmk1zjafrn6jh4j7r0wkwrpwvf9drl1lcw8vya23i1f4zbk0wh4";
  };

  nativeBuildInputs = [ autoreconfHook which pkgconfig ];

  buildInputs = [ libxcb json-glib gtk-doc xorgproto gobject-introspection ];


  preAutoreconf = ''
    gtkdocize
  '';

  meta = with stdenv.lib; {
    description = "A C interface library to i3wm";
    homepage = https://github.com/acrisci/i3ipc-glib;
    maintainers = with maintainers; [teto];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
