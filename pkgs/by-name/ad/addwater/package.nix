{
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  lib,
  libadwaita,
  libportal-gtk4,
  meson,
  ninja,
  python3Packages,
  wrapGAppsHook4,
  appstream,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "addwater";
  version = "1.2.9";
  # built with meson, not a python format
  pyproject = false;

  src = fetchFromGitHub {
    owner = "largestgithubuseronearth";
    repo = "addwater";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ii6xzt4BFroLAf4fHK0GbXa/aSzKffiN2FjMju+tnRo=";
  };

  buildInputs = [
    libadwaita
    libportal-gtk4
  ];

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    wrapGAppsHook4
    appstream
  ];

  propagatedBuildInputs = with python3Packages; [
    packaging
    pygobject3
    requests
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Installer for the fantastic GNOME for Firefox theme";
    homepage = "https://github.com/largestgithubuseronearth/addwater";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ thtrf ];
    mainProgram = "addwater";
    platforms = lib.platforms.linux;
  };
})
