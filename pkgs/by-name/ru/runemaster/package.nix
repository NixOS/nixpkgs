{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  gjs,
  gtk4,
  libadwaita,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "runemaster";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "johnfactotum";
    repo = "runemaster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bS/AzvelwQYIJvfK3XbvlQ8300/acHQPQTu0owYETqk=";
  };

  buildInputs = [
    pkg-config
    meson
  ];
  nativeBuildInputs = [
    gjs
    gtk4
    libadwaita
  ];

  meta = {
    description = "Unleash the magic of Unicode characters";
    homepage = "https://github.com/johnfactotum/runemaster/";
    changelog = "https://github.com/johnfactotum/runemaster/release/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.awwpotato ];
    mainProgram = "runemaster";
  };
})
