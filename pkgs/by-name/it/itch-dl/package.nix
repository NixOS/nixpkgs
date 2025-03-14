{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "itch-dl";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DragoonAethis";
    repo = "itch-dl";
    tag = version;
    hash = "sha256-MkhXM9CQXbVcnztMPnBscryXWSaSQUeoG6KtVuS8YEo=";
  };

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    lxml
    pydantic
    requests
    tqdm
    urllib3
  ];

  pythonRelaxDeps = [
    "pydantic"
    "urllib3"
  ];

  meta = {
    description = "Itch.io game downloader with website, game jam, collection and library support";
    mainProgram = "itch-dl";
    homepage = "https://github.com/DragoonAethis/itch-dl";
    changelog = "https://github.com/DragoonAethis/itch-dl/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
