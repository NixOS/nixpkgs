{
  desktop-file-utils,
  fetchFromGitHub,
  gettext,
  gtk4,
  lib,
  libadwaita,
  libportal-gtk4,
  meson,
  ninja,
  pkg-config,
  stdenv,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kasasa";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "KelvinNovais";
    repo = "Kasasa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y5Ml5kHKk5f1RcRKdvS/9JO0dIWpotU1qtjjmpDJ1f4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    gettext
  ];

  buildInputs = [
    gtk4
    libadwaita
    libportal-gtk4
  ];

  meta = {
    description = "Snip and pin useful information to a small floating window";
    longDescription = ''
      Clip and pin what's important to a small floating window, so you don't
      have to switch between windows or workspaces repeatedly. The window can
      become miniaturized or have its opacity reduced, in order to not block
      what's behind it.
    '';
    homepage = "https://github.com/KelvinNovais/Kasasa";
    license = lib.licenses.gpl3Plus;
    mainProgram = "kasasa";
    maintainers = with lib.maintainers; [ yajo ];
    platforms = lib.platforms.linux;
  };
})
