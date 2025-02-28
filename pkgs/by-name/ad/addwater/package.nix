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

python3Packages.buildPythonApplication rec {
  pname = "addwater";
  version = "1.2.5";
  # built with meson, not a python format
  pyproject = false;

  src = fetchFromGitHub {
    owner = "largestgithubuseronearth";
    repo = "addwater";
    tag = "v${version}";
    hash = "sha256-Klz7FYlvkiokoISXsVvyWGKWR/MVhpj4OjQQhvPzju4=";
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
}
