{ lib
, stdenv
, fetchurl
, fetchpatch
, wrapGAppsHook4
, cargo
, desktop-file-utils
, meson
, ninja
, pkg-config
, rustc
, gdk-pixbuf
, glib
, gtk4
, gtksourceview5
, libadwaita
, darwin
}:

stdenv.mkDerivation rec {
  pname = "icon-library";
  version = "0.0.17";

  src = fetchurl {
    url = "https://gitlab.gnome.org/World/design/icon-library/uploads/8c4cad88809cd4ddc0eeae6f5170c001/icon-library-${version}.tar.xz";
    hash = "sha256-Gspx3fJl+ZoUN3heGWaeMuxUsjWCrIdg4pJj7DeMTSY=";
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustc
    wrapGAppsHook4
  ];
  buildInputs = [
    gdk-pixbuf
    glib
    gtk4
    gtksourceview5
    libadwaita
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
