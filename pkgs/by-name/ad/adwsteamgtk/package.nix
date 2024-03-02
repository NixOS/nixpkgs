{ blueprint-compiler
, desktop-file-utils
, fetchFromGitHub
, lib
, libadwaita
, libportal-gtk4
, meson
, ninja
, python3Packages
, wrapGAppsHook4
}:

python3Packages.buildPythonApplication rec {
  pname = "adwsteamgtk";
  version = "0.6.9";
  # built with meson, not a python format
  format = "other";

  src = fetchFromGitHub {
    owner = "Foldex";
    repo = "AdwSteamGtk";
    rev = "v${version}";
    hash = "sha256-aHJxgSb7oZTRrfFVYdLimwhSGzdRjGf7dGTRA+ANQiM=";
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
    description = "A simple Gtk wrapper for Adwaita-for-Steam";
    homepage = "https://github.com/Foldex/AdwSteamGtk";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.reedrw ];
    mainProgram = "adwaita-steam-gtk";
    platforms = lib.platforms.linux;
  };
}
