{
  lib,
  stdenv,
  fetchFromGitLab,
  buildPackages,
  cargo,
  meson,
  ninja,
  pkg-config,
  desktop-file-utils,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  gettext,
  glib,
  gtk4,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bustle";
  version = "0.12.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "bustle";
    tag = finalAttrs.version;
    hash = "sha256-gzPFODVLvv+Ore1XR+XTi2fjVh3OJOZF0k9vilVnst4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-DYkicVDjQRIMfKl0f9aLWIyQfR153I43EpSuskenmoA=";
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
    meson
    ninja
    pkg-config
    desktop-file-utils
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    glib
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = {
    description = "Graphical D-Bus message analyser and profiler";
    homepage = "https://gitlab.gnome.org/World/bustle";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      jtojnar
    ];
    teams = [ lib.teams.gnome-circle ];
    mainProgram = "bustle";
    platforms = lib.platforms.unix;
  };
})
