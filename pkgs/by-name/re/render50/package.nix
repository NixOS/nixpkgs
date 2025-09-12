{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "render50";
  version = "9.2.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "render50";
    tag = "v${version}";
    hash = "sha256-YaLLWrae8vgOYLmfFlPa6WkKGNlUj+n76NRpg0qm6QI=";
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
    changelog = "https://github.com/cs50/render50/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "render50";
  };
}
