{
  stdenv,
  lib,
  fetchFromGitLab,
  cairo,
  cargo,
  desktop-file-utils,
  gettext,
  glib,
  gtk4,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pango,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "contrast";
  version = "0.0.10";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "contrast";
    rev = version;
    hash = "sha256-Y0CynBvnCOBesONpxUicR7PgMJgmM0ZQX/uOwIppj7w=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-BdwY2YDJyDApGgE0Whz3xRU/0gRbkwbKUvPbWEObXE8=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    glib
    gtk4
    libadwaita
    pango
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Checks whether the contrast between two colors meet the WCAG requirements";
    homepage = "https://gitlab.gnome.org/World/design/contrast";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "contrast";
    platforms = lib.platforms.linux;
  };
}
