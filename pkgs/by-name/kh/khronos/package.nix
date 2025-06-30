{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  vala,
  pkg-config,
  desktop-file-utils,
  glib,
  gtk4,
  json-glib,
  libadwaita,
  libgee,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "khronos";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = "khronos";
    rev = version;
    sha256 = "sha256-2mO2ZMDxZ7sx2EVTN0tsAv8MisGxlK/1h61N+hOqyGI=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    json-glib
    libadwaita
    libgee
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Track each task's time in a simple inobtrusive way";
    homepage = "https://github.com/lainsce/khronos";
    maintainers = with maintainers; [ xiorcale ];
    teams = [ teams.pantheon ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    mainProgram = "io.github.lainsce.Khronos";
  };
}
