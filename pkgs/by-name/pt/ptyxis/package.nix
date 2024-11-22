{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  json-glib,
  vte-gtk4,
  libportal-gtk4,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ptyxis";
  version = "47.5";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "chergert";
    repo = "ptyxis";
    rev = finalAttrs.version;
    hash = "sha256-h5e+H4Tf7T1poM1Srf/ZINk5chScXNFLaEqtlMgrhHs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    json-glib
    vte-gtk4
    libportal-gtk4
    pcre2
  ];

  meta = {
    description = "Terminal for GNOME with first-class support for containers";
    homepage = "https://gitlab.gnome.org/chergert/ptyxis";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ptyxis";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
