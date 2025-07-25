{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "contact";
  version = "1.3.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdxlocations";
    repo = "contact";
    tag = version;
    hash = "sha256-Fezjvs+aP2Qlp0A6P4/5QogVOHkxRaey9ZkI70va19Y=";
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
