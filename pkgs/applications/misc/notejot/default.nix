{ lib
, stdenv
, fetchFromGitHub
, gtk4
, json-glib
, libadwaita
, libgee
, desktop-file-utils
, meson
, ninja
, nix-update-script
, pkg-config
, vala
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "notejot";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    hash = "sha256-p5F0OITgfZyvHwndI5r5BE524+nft7A2XfR3BJZFamU=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    json-glib
    libadwaita
    libgee
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/lainsce/notejot";
    description = "Stupidly-simple notes app";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
    mainProgram = "io.github.lainsce.Notejot";
  };
}
