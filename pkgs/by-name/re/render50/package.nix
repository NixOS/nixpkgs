{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "render50";
  version = "9.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "render50";
    tag = "v${version}";
    hash = "sha256-ZCSd1Y7PPVkMQWkEgcaqh3Ypy8OrWxI9iM2HMVT/VeA=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    backports-shutil-which
    braceexpand
    beautifulsoup4
    natsort
    pygments
    pypdf
    requests
    six
    termcolor
    weasyprint
  ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  # no pytest checks

  meta = {
    description = "Generate syntax-highlighted PDFs of source code";
    homepage = "https://cs50.readthedocs.io/render50/";
    downloadPage = "https://github.com/cs50/render50";
    changelog = "https://github.com/cs50/render50/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "render50";
  };
}
