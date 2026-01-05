{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  desktop-file-utils,
  pantheon,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  glib,
  gtk3,
  libgee,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "agenda";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "dahenson";
    repo = "agenda";
    tag = version;
    hash = "sha256-CjlGkG43FFDdKGuwevBeCCazOzLcH114bqihMWTykC8=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libgee
    pantheon.granite
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Simple, fast, no-nonsense to-do (task) list designed for elementary OS";
    homepage = "https://github.com/dahenson/agenda";
    maintainers = with maintainers; [ xiorcale ];
    teams = [ teams.pantheon ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    mainProgram = "com.github.dahenson.agenda";
  };
}
