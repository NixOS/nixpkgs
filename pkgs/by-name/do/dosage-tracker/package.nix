{
  lib,
  stdenv,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  gjs,
  glib,
  gtk4,
  libadwaita,
  libportal,
  meson,
  ninja,
  nix-update-script,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dosage";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "diegopvlk";
    repo = "Dosage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-euGyTaufL8Ifsy1RT4jcqlz8XZfCN7GfvFFvo85f/3c=";
  };

  # https://github.com/NixOS/nixpkgs/issues/318830
  postPatch = ''
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 'io.github.diegopvlk.Dosage';" src/io.github.diegopvlk.Dosage.in
  '';

  strictDeps = true;

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    gjs
    glib # For `glib-compile-schemas`
    gtk4 # For `gtk-update-icon-theme`
    meson
    ninja
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    libadwaita
    libportal
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Medication tracker for Linux";
    homepage = "https://github.com/diegopvlk/Dosage";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "io.github.diegopvlk.Dosage";
    platforms = lib.platforms.linux;
  };
})
