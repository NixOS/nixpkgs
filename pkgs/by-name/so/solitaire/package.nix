{
  adwaita-icon-theme,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  fetchFromGitLab,
  glib,
  gtk4,
  lib,
  libadwaita,
  libxml2,
  meson,
  ninja,
  pkg-config,
  rustc,
  rustPlatform,
  stdenv,
  vala,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "solitaire";
  version = "51.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "wwarner";
    repo = "Solitaire";
    tag = finalAttrs.version;
    hash = "sha256-0AYXslQ/W7LojHiVOQvKUynx68rordHNBS4UAyN5o8w=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-xj4k6F81ZjjshOJODhEJL83+CvMfQ2CI0SOvaPNbabU=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils # update-desktop-database
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    adwaita-icon-theme
    glib
    gtk4
    libadwaita
    libxml2
  ];

  mesonBuildType = "release";

  # Icons aren't wrapped correctly by default
  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${adwaita-icon-theme}/share")
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    changelog = "https://gitlab.gnome.org/wwarner/Solitaire/-/blob/${finalAttrs.src.tag}/NEWS";
    description = "Solitaire for your Linux desktop";
    homepage = "https://gitlab.gnome.org/wwarner/Solitaire";
    license = lib.licenses.gpl3Plus;
    mainProgram = "solitaire";
    maintainers = with lib.maintainers; [ hythera ];
    platforms = lib.platforms.linux;
  };
})
