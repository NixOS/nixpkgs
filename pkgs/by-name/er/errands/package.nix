{
  lib,
  fetchFromGitHub,
  python3Packages,
  gobject-introspection,
  libadwaita,
  wrapGAppsHook4,
  meson,
  ninja,
  desktop-file-utils,
  pkg-config,
  appstream,
  libsecret,
  libportal,
  gtk4,
  gtksourceview5,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "errands";
  version = "46.2.10";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "mrvladus";
    repo = "Errands";
    tag = finalAttrs.version;
    hash = "sha256-YgKn6tBW1gG6H1zEAzaQjJWzSXh4Na44yZ7lfAnqUFA=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
    meson
    ninja
    pkg-config
    appstream
    gtk4
  ];

  buildInputs = [
    libadwaita
    libportal
    libsecret
    gtksourceview5
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    lxml
    caldav
    pycryptodomex
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Manage your tasks";
    changelog = "https://github.com/mrvladus/Errands/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/mrvladus/Errands";
    license = lib.licenses.mit;
    mainProgram = "errands";
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      sund3RRR
    ];
    teams = [ lib.teams.gnome-circle ];
  };
})
