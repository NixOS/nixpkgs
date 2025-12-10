{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "contact";
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdxlocations";
    repo = "contact";
    tag = version;
    hash = "sha256-YLg4+AxtF0ZZe5nJMOcg1pPetdcKRnQlpADyYROP/EY=";
  };

  dependencies = [ python3Packages.meshtastic ];

  build-system = [ python3Packages.poetry-core ];

  meta = {
    homepage = "https://github.com/pdxlocations/contact";
    changelog = "https://github.com/pdxlocations/contact/releases/tag/${src.tag}";
    description = "Console UI for Meshtastic";
    mainProgram = "contact";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      sarcasticadmin
    ];
    platforms = lib.platforms.unix;
  };
}
