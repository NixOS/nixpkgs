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
}:

python3Packages.buildPythonApplication rec {
  pname = "adwsteamgtk";
  version = "0.7.2";
  # built with meson, not a python format
  format = "other";

  src = fetchFromGitHub {
    owner = "Foldex";
    repo = "AdwSteamGtk";
    rev = "refs/tags/v${version}";
    hash = "sha256-DI5WK8CtoyH8hSogQx5/oDCrGoLxE06cy63ubU+e3bQ=";
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
  ];

  propagatedBuildInputs = with python3Packages; [
    packaging
    pygobject3
  ];

  meta = {
    description = "Simple Gtk wrapper for Adwaita-for-Steam";
    homepage = "https://github.com/Foldex/AdwSteamGtk";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.reedrw ];
    mainProgram = "adwaita-steam-gtk";
    platforms = lib.platforms.linux;
  };
}
