{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk4,
  json-glib,
  libadwaita,
  libgee,
  desktop-file-utils,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  vala,
  wrapGAppsHook4,
  fetchpatch,
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

  patches = [
    # Fixes the compilation error with new Vala compiler. Remove in the next version.
    (fetchpatch {
      url = "https://github.com/musicinmybrain/notejot/commit/c6a7cfcb792de63fb51eb174f9f3d4e02f6a2ce1.patch";
      hash = "sha256-dexPKIpUaAu/p0K2WQpElhPNt86CS+jD0dPL5+CTl4I=";
    })
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
