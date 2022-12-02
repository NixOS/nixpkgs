{ lib, stdenv, fetchurl, fetchpatch, wrapGAppsHook4
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

  patches = [
    # Fix build with meson 0.61
    # data/meson.build:85:0: ERROR: gnome.compile_resources takes exactly 2 arguments, but got 3.
    # https://gitlab.gnome.org/World/design/icon-library/-/merge_requests/54
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/design/icon-library/-/commit/c629dbf6670f9bb0b98ff21c17110489b58f5c85.patch";
      sha256 = "UKC1CPaM58/z0zINN794luWZdoFx1zGxETPb8VtbO3E=";
    })
  ];

  nativeBuildInputs = [
    cargo desktop-file-utils meson ninja pkg-config rustc wrapGAppsHook4
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
