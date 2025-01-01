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
}:

python3Packages.buildPythonApplication rec {
  pname = "addwater";
  version = "1.1.6";
  # built with meson, not a python format
  pyproject = false;

  src = fetchFromGitHub {
    owner = "largestgithubuseronearth";
    repo = "addwater";
    rev = "refs/tags/v${version}";
    hash = "sha256-5iuSRA18TWj6naw5MraGZ1Y9OUWEVg2oKqQtkC8rMWw=";
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

  meta = {
    description = "Installer for the fantastic GNOME for Firefox theme";
    homepage = "https://github.com/largestgithubuseronearth/addwater";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ thtrf ];
    mainProgram = "addwater";
    platforms = lib.platforms.linux;
  };
}
