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
  rustPlatform,
  gettext,
  gdk-pixbuf,
  glib,
  gtk4,
  gtksourceview5,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icon-library";
  version = "0.0.22";

  src = fetchurl {
    url = "https://gitlab.gnome.org/World/design/icon-library/-/releases/${finalAttrs.version}/downloads/icon-library-${finalAttrs.version}.tar.xz";
    hash = "sha256-2Yh50TH+MHGpW1lZZXJ0FbP6VwPTmuesfhAZNSIt0bw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-OkVUAQnui0PzYXjoC6nTcLNqD/TLkz5pVtjV+7KSUq4=";
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
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];
  buildInputs = [
    gdk-pixbuf
    glib
    gtk4
    gtksourceview5
    libadwaita
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/World/design/icon-library";
    description = "Symbolic icons for your apps";
    mainProgram = "icon-library";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
