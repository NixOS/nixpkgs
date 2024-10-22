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
  version = "46.6";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "chergert";
    repo = "ptyxis";
    rev = finalAttrs.version;
    hash = "sha256-exsb5+5jxUKRHDaaBG3rJcJoqLGa6n/dsMlDtwUGfJo=";
  };

  # FIXME: drop patched vte-gtk4 in 47.x release
  vte-gtk4-patched = vte-gtk4.overrideAttrs (prev: {
    patches = (prev.patches or [ ]) ++ [
      "${finalAttrs.src}/build-aux/0001-a11y-implement-GtkAccessibleText.patch"
      "${finalAttrs.src}/build-aux/0001-add-notification-and-shell-precmd-preexec.patch"
    ];
  });

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
    finalAttrs.vte-gtk4-patched
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
