{
  lib,
  rustPlatform,
  fetchurl,
  wrapGAppsHook4,
  meson,
  vala,
  pkg-config,
  ninja,
  itstool,
  gnome,
  gtk4,
  libadwaita,
  stdenv,
  rustc,
  cargo,
  desktop-file-utils,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-2048";
  version = "50.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-2048/${lib.versions.major finalAttrs.version}/gnome-2048-${finalAttrs.version}.tar.xz";
    hash = "sha256-bRXfaKYSjPDJnlmJCK+MZntzPcQAPvTSHUtMSkK9Lak=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-OcuhISJhm8uvcJjki86FSNiT5AoqUrILZaHcn1oZVtk=";
  };

  strictDeps = true;
  __structuredArgs = true;

  nativeBuildInputs = [
    itstool
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    rustc
    cargo
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    rustPlatform.cargoCheckHook
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-2048";
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-2048";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-2048/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Obtain the 2048 tile";
    mainProgram = "gnome-2048";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
