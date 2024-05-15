{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  desktop-file-utils,
  wrapGAppsHook4,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  glib-networking,
  gtk4,
  json-glib,
  libadwaita,
  libarchive,
  libgee,
  libsoup_3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "protonplus";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "Vysp3r";
    repo = "protonplus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dKhGXpsBCZBNNJRAjzSvP0B/3DbS9wRdhTS4WL2NZjE=";
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
    glib
    glib-networking
    gtk4
    json-glib
    libadwaita
    libarchive
    libgee
    libsoup_3
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    mainProgram = "com.vysp3r.ProtonPlus";
    description = "A simple Wine and Proton-based compatibility tools manager";
    homepage = "https://github.com/Vysp3r/ProtonPlus";
    changelog = "https://github.com/Vysp3r/ProtonPlus/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ getchoo ];
    platforms = platforms.linux;
  };
})
