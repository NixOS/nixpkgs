{
  lib,
  python312Packages,
  fetchFromGitHub,
}:

# ao3downloader explicitly does not support Python 3.13 yet
# https://github.com/nianeyna/ao3downloader/blob/f8399bb8aca276ae7359157b90afd13925c90056/pyproject.toml#L8
python312Packages.buildPythonApplication rec {
  pname = "ao3downloader";
  version = "2025.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nianeyna";
    repo = "ao3downloader";
    tag = "v${version}";
    hash = "sha256-ukS3uku8OW5nhM2Nr0IxAiG03XfqUn/Xyd0lZDGGkWw=";
  };

  build-system = with python312Packages; [
    hatchling
  ];

  dependencies = with python312Packages; [
    beautifulsoup4
    mobi
    pdfquery
    requests
    six
    tqdm
  ];

  pythonRelaxDeps = [
    "requests"
  ];

  pythonImportsCheck = [
    "ao3downloader"
  ];

  nativeCheckInputs = with python312Packages; [
    pytestCheckHook
    syrupy
    pythonImportsCheckHook
  ];

  meta = {
    description = "Utility for downloading fanfiction in bulk from the Archive of Our Own";
    changelog = "https://github.com/nianeyna/ao3downloader/releases/tag/v${version}";
    mainProgram = "ao3downloader";
    homepage = "https://nianeyna.dev/ao3downloader";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.samasaur ];
  };
}
