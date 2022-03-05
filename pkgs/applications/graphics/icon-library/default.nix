{ lib, stdenv, fetchurl, wrapGAppsHook
, cargo, desktop-file-utils, meson, ninja, pkg-config, python3, rustc
, dbus, gdk-pixbuf, glib, gtk3, gtksourceview4, libhandy
}:

stdenv.mkDerivation rec {
  pname = "icon-library";
  version = "0.0.8";

  src = fetchurl {
    url = "https://gitlab.gnome.org/World/design/icon-library/uploads/fdf890706e0eef2458a5285e3bf65dd5/icon-library-${version}.tar.xz";
    sha256 = "0807b56bgm8j1gpq4nf8x31gq9wqhcmpzpkqw6s4wissw3cb7q96";
  };

  nativeBuildInputs = [
    cargo desktop-file-utils meson ninja pkg-config python3 rustc wrapGAppsHook
  ];
  buildInputs = [ dbus gdk-pixbuf glib gtk3 gtksourceview4 libhandy ];

  postPatch = ''
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/design/icon-library";
    description = "Symbolic icons for your apps";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
