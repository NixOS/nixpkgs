{ lib
, stdenv
, fetchFromGitHub
, gtk4
, hicolor-icon-theme
, json-glib
, libadwaita
, libgee
, meson
, ninja
, nix-update-script
, pkg-config
, python3
, vala
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "notejot";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    hash = "sha256-WyW1tGhO3+OykNa8BRavi93cBMOSBJw0M+0bwQHJOjU=";
  };

  patches = [
    # build: use gtk4-update-icon-cache
    # https://github.com/lainsce/notejot/pull/307
    ./use-gtk4-update-icon-cache.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    hicolor-icon-theme
    json-glib
    libadwaita
    libgee
  ];

  postPatch = ''
    chmod +x build-aux/post_install.py
    patchShebangs build-aux/post_install.py
  '';

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    homepage = "https://github.com/lainsce/notejot";
    description = "Stupidly-simple sticky notes applet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "io.github.lainsce.Notejot";
  };
}
