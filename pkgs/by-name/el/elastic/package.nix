{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, vala
, gtk4
, libgee
, libadwaita
, gtksourceview5
, blueprint-compiler
, wrapGAppsHook4
, desktop-file-utils
, template-glib
}:

stdenv.mkDerivation rec {
  pname = "elastic";
  version = "0.1.5";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "elastic";
    rev = version;
    hash = "sha256-y/XBXN5RIqnFmxnmkThBGW0B5owgy/1Q/6jmkBCi+rk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    blueprint-compiler
  ];

  buildInputs = [
    gtk4
    libadwaita
    libgee
    gtksourceview5
    template-glib
  ];

  meta = with lib; {
    description = "Design spring animations";
    homepage = "https://gitlab.gnome.org/World/elastic/";
    mainProgram = "app.drey.Elastic";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0xMRTT ] ++ lib.teams.gnome-circle.members;
  };
}
