{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  gjs,
  webkitgtk_6_0,
  glib-networking,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quick-lookup";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "johnfactotum";
    repo = "quick-lookup";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-I6a8J/Z1yJhdqWES+1mIlvJq6FBOX0GiW0muNP/iSjE=";
  };

  postPatch = ''
    substituteInPlace post_install.py \
      --replace-fail 'gtk-update-icon-cache' 'gtk4-update-icon-cache'
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    gjs
    webkitgtk_6_0
    glib-networking
  ];

  meta = {
    description = "Simple GTK dictionary application powered by Wiktionary";
    homepage = "https://github.com/johnfactotum/quick-lookup";
    license = lib.licenses.gpl3Plus;
    mainProgram = "quick-lookup";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
