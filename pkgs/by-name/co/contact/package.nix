{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "contact";
  version = "1.5.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdxlocations";
    repo = "contact";
    tag = finalAttrs.version;
    hash = "sha256-nuhlxKE6o2kNMz5VRV0SIY4Hee5thBbV71Ex6mM1AXo=";
  };

  dependencies = [ python3Packages.meshtastic ];

  build-system = [ python3Packages.poetry-core ];

  meta = {
    homepage = "https://github.com/pdxlocations/contact";
    changelog = "https://github.com/pdxlocations/contact/releases/tag/${finalAttrs.src.tag}";
    description = "Console UI for Meshtastic";
    mainProgram = "contact";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      sarcasticadmin
    ];
    platforms = lib.platforms.unix;
  };
})
