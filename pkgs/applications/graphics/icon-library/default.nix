{ lib, stdenv, fetchurl, wrapGAppsHook
, cargo, desktop-file-utils, meson, ninja, pkg-config, rustc
, gdk-pixbuf, glib, gtk4, gtksourceview5, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "icon-library";
  version = "0.0.11";

  src = fetchurl {
    url = "https://gitlab.gnome.org/World/design/icon-library/uploads/93d183b17d216bbed7b03b2f3698059c/icon-library-${version}.tar.xz";
    sha256 = "1zrcnc5dn5fgcl3vklfpbp3m0qzi2n2viw59vw5fhwkysvp670y7";
  };

  nativeBuildInputs = [
    cargo desktop-file-utils meson ninja pkg-config rustc wrapGAppsHook
  ];
  buildInputs = [ gdk-pixbuf glib gtk4 gtksourceview5 libadwaita ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/design/icon-library";
    description = "Symbolic icons for your apps";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
