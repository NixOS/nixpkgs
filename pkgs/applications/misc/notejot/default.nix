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
  version = "3.4.9";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    hash = "sha256-42k9CAnXAb7Ic580SIa95MDCkCWtso1F+0eD69HX8WI=";
  };

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
    description = "Stupidly-simple notes app";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
    mainProgram = "io.github.lainsce.Notejot";
  };
}
