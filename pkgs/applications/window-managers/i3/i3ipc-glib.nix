{ lib, stdenv, fetchFromGitHub, pkg-config, xorgproto, libxcb
, autoreconfHook, json-glib, gtk-doc, which
, gobject-introspection
}:

stdenv.mkDerivation rec {

  pname = "i3ipc-glib";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "i3ipc-glib";
    rev = "v${version}";
    sha256 = "01fzvrbnzcwx0vxw29igfpza9zwzp2s7msmzb92v01z0rz0y5m0p";
  };

  nativeBuildInputs = [ autoreconfHook which pkg-config ];

  buildInputs = [ libxcb json-glib gtk-doc xorgproto gobject-introspection ];


  preAutoreconf = ''
    gtkdocize
  '';

  meta = with lib; {
    description = "A C interface library to i3wm";
    homepage = "https://github.com/acrisci/i3ipc-glib";
    maintainers = with maintainers; [teto];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
