{
  lib,
  fetchFromGitHub,
  gtk4,
  libadwaita,
  libportal,
  meson,
  ninja,
  pkg-config,
  stdenv,
  vala,
  wrapGAppsHook4,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clairvoyant";
  version = "3.1.8";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "clairvoyant";
    rev = finalAttrs.version;
    hash = "sha256-SksJ0hOt2CJwrQj4dz63D53GM/PYx7Q/g+OgCo76dIE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libportal
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/cassidyjames/clairvoyant/releases/tag/${finalAttrs.version}";
    description = "Ask questions, get psychic answers";
    homepage = "https://github.com/cassidyjames/clairvoyant";
    license = lib.licenses.gpl3Plus;
    mainProgram = "com.github.cassidyjames.clairvoyant";
    maintainers = lib.teams.gnome-circle.members;
  };
})
