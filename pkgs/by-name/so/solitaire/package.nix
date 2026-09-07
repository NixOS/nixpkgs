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
  version = "50.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "wwarner";
    repo = "Solitaire";
    tag = finalAttrs.version;
    hash = "sha256-byQvT4vPs+hpp9DoJatBc5my/KuFbRiSgtz6Al8lOIk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-xYxAONSoBW40Bbq8/KmxZtIlAHUmIj+h++GHhXyrcpU=";
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

  meta = {
    changelog = "https://gitlab.gnome.org/wwarner/Solitaire/-/blob/${finalAttrs.src.tag}/NEWS";
    description = "Solitaire for your Linux desktop";
    homepage = "https://gitlab.gnome.org/wwarner/Solitaire";
    license = lib.licenses.gpl3Plus;
    mainProgram = "solitaire";
    maintainers = with lib.maintainers; [ hythera ];
    platforms = lib.platforms.unix;
  };
})
