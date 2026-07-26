{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "itch-dl";
  version = "0.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DragoonAethis";
    repo = "itch-dl";
    tag = finalAttrs.version;
    hash = "sha256-4+Idh76o/VbdQ6hgvQsrz9AGYeOGC2hgN0kMJz+ik2E=";
  };

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
  ];

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    lxml
    requests
    tqdm
    urllib3
  ];

  pythonRelaxDeps = [
    "urllib3"
    "beautifulsoup4"
    "lxml"
    "tqdm"
  ];

  meta = {
    description = "Itch.io game downloader with website, game jam, collection and library support";
    mainProgram = "itch-dl";
    homepage = "https://github.com/DragoonAethis/itch-dl";
    changelog = "https://github.com/DragoonAethis/itch-dl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
