{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gettext,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  gtksourceview5,
  webkitgtk_6_0,
  discount,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bookup";
  version = "1.1.5";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "ilhooq";
    repo = "bookup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s2j9AQMDJaKtYyXtHDscujPv2KIvO0pnX/OnXma93Ro=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext # msgfmt
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    gtksourceview5
    webkitgtk_6_0
    discount
    sqlite
  ];

  meta = {
    description = "Markdown note-taking application for Gnome";
    homepage = "https://gitlab.gnome.org/ilhooq/bookup";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "bookup";
  };
})
