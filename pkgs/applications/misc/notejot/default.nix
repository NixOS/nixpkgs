{ lib
, stdenv
, fetchFromGitHub
, gtk4
, gtksourceview
, json-glib
, libadwaita
, libgee
, meson
, ninja
, nix-update-script
, pantheon
, pkg-config
, python3
, vala
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "notejot";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    hash = "sha256-p8rca3PsnT/3Lp6W30VvqR9aPr6EIuNrH5gsxL0lZ0Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    python3
    wrapGAppsHook
  ];
  buildInputs = [
    gtk4
    gtksourceview
    json-glib
    libadwaita
    libgee
    pantheon.elementary-icon-theme
    pantheon.granite
  ];

  postPatch = ''
    chmod +x build-aux/post_install.py
    patchShebangs build-aux/post_install.py
  '';

  meta = with lib; {
    homepage = "https://github.com/lainsce/notejot";
    description = "Stupidly-simple sticky notes applet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ] ++ teams.pantheon.members;
    platforms = platforms.linux;
  };

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };
}
