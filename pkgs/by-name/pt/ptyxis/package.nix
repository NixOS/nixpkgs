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

let
  version = "46.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "chergert";
    repo = "ptyxis";
    rev = version;
    hash = "sha256-DKZgnistOv6eFWtqYPtMc1tQJWovCWIqrqGgs9uWu5k=";
  };

  vte-gtk4-patched = vte-gtk4.overrideAttrs (prev: {
    patches = (prev.patches or [ ]) ++ [
      "${src}/build-aux/0001-add-notification-and-shell-precmd-preexec.patch"
    ];
  });
in
stdenv.mkDerivation {
  pname = "ptyxis";
  inherit version src;

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
    vte-gtk4-patched
    libportal-gtk4
    pcre2
  ];

  passthru = {
    inherit vte-gtk4-patched;
  };

  meta = {
    description = "Terminal for GNOME with first-class support for containers";
    homepage = "https://gitlab.gnome.org/chergert/ptyxis";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ptyxis";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
