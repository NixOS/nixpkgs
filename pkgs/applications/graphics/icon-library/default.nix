{ lib, stdenv, fetchurl, fetchpatch, wrapGAppsHook4
, cargo, desktop-file-utils, meson, ninja, pkg-config, rustc
, gdk-pixbuf, glib, gtk4, gtksourceview5, libadwaita, darwin
}:

stdenv.mkDerivation rec {
  pname = "icon-library";
  version = "0.0.16";

  src = fetchurl {
    url = "https://gitlab.gnome.org/World/design/icon-library/uploads/5dd3d97acfdbaf69c7dc6b2f7bbf4cae/icon-library-${version}.tar.xz";
    hash = "sha256-EO67foD/uRoeF+zmJyEia5Nr3eW+Se9bVjDxipMw75E=";
  };

  nativeBuildInputs = [
    cargo desktop-file-utils meson ninja pkg-config rustc wrapGAppsHook4
  ];
  buildInputs = [
    gdk-pixbuf glib gtk4 gtksourceview5 libadwaita
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/design/icon-library";
    description = "Symbolic icons for your apps";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
