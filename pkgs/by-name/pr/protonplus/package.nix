{
  lib,
  stdenv,
  fetchFromGitHub,
  desktop-file-utils,
  glib,
  glib-networking,
  gtk4,
  json-glib,
  libadwaita,
  libarchive,
  libgee,
  libsoup_3,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  vala,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "protonplus";
  version = "0.4.17";

  src = fetchFromGitHub {
    owner = "Vysp3r";
    repo = "protonplus";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-2M/RMm2zoFjRbuJmRtH9Nl1lhvHYmXoWzjH3+8eK360=";
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

  meta = {
    description = "Simple Wine and Proton-based compatibility tools manager";
    homepage = "https://github.com/Vysp3r/ProtonPlus";
    changelog = "https://github.com/Vysp3r/ProtonPlus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "com.vysp3r.ProtonPlus";
    platforms = lib.platforms.linux;
  };
})
