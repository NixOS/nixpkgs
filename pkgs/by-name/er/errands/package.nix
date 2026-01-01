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
python3Packages.buildPythonApplication rec {
  pname = "errands";
<<<<<<< HEAD
  version = "46.2.10";
=======
  version = "46.2.9";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pyproject = false;

  src = fetchFromGitHub {
    owner = "mrvladus";
    repo = "Errands";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-YgKn6tBW1gG6H1zEAzaQjJWzSXh4Na44yZ7lfAnqUFA=";
=======
    hash = "sha256-+x6zp14leFryxwQJdI0UKPp4N0IuJRIX5/94QrlzDAU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    changelog = "https://github.com/mrvladus/Errands/releases/tag/${version}";
    homepage = "https://github.com/mrvladus/Errands";
    license = lib.licenses.mit;
    mainProgram = "errands";
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      sund3RRR
    ];
    teams = [ lib.teams.gnome-circle ];
  };
}
