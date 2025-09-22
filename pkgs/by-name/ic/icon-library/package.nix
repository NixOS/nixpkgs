{
  lib,
  stdenv,
  fetchurl,
  wrapGAppsHook4,
  buildPackages,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustc,
  gettext,
  gdk-pixbuf,
  glib,
  gtk4,
  gtksourceview5,
  libadwaita,
}:

stdenv.mkDerivation rec {
  pname = "icon-library";
  version = "0.0.19";

  src = fetchurl {
    url = "https://gitlab.gnome.org/World/design/icon-library/uploads/7725604ce39be278abe7c47288085919/icon-library-${version}.tar.xz";
    hash = "sha256-nWGTYoSa0/fxnD0Mb2132LkeB1oa/gj/oIXBbI+FDw8=";
  };

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Set the location to gettext to ensure the nixpkgs one on Darwin instead of the vendored one.
    # The vendored gettext does not build with clang 16.
    GETTEXT_BIN_DIR = "${lib.getBin buildPackages.gettext}/bin";
    GETTEXT_INCLUDE_DIR = "${lib.getDev gettext}/include";
    GETTEXT_LIB_DIR = "${lib.getLib gettext}/lib";
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
