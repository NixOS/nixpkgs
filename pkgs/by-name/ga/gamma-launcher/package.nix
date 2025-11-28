{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "gamma-launcher";
  version = "2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mord3rca";
    repo = "gamma-launcher";
    tag = "v${version}";
    hash = "sha256-qzjfgDFimEL6vtsJBubY6fHsokilDB248WwHJt3F7fI=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    beautifulsoup4
    cloudscraper
    gitpython
    platformdirs
    py7zr
    python-unrar
    requests
    tenacity
    tqdm
  ];

  nativeCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Python cli to download S.T.A.L.K.E.R. GAMMA";
    changelog = "https://github.com/Mord3rca/gamma-launcher/releases/tag/v${version}";
    homepage = "https://github.com/Mord3rca/gamma-launcher";
    mainProgram = "gamma-launcher";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ DrymarchonShaun ];
    platforms = lib.platforms.linux;
  };
}
