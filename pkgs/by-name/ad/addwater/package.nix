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
<<<<<<< HEAD
  version = "1.2.7";
=======
  version = "1.2.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # built with meson, not a python format
  pyproject = false;

  src = fetchFromGitHub {
    owner = "largestgithubuseronearth";
    repo = "addwater";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-NZOjY+cskKn+BppqBSJyFR1JdDL56whDW19a15cvShE=";
=======
    hash = "sha256-J1bWJUtQ8V1UuH+hfU0jIy/LQRFjzzV1YvI/VIaCjJE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
