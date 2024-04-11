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
  version = "0.0.18";

  src = fetchurl {
    url = "https://gitlab.gnome.org/World/design/icon-library/uploads/874b27fcf34662d9686f670d406142c2/icon-library-${version}.tar.xz";
    hash = "sha256-qCGwTePA817mulFjyRZKw+Fw1S77+QTtA7WH+KocL48=";
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
    mainProgram = "icon-library";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
