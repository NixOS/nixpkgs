{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "render50";
  version = "9.2.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "render50";
    tag = "v${finalAttrs.version}";
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

  # no pytest checks

  meta = {
    description = "Generate syntax-highlighted PDFs of source code";
    homepage = "https://cs50.readthedocs.io/render50/";
    downloadPage = "https://github.com/cs50/render50";
    changelog = "https://github.com/cs50/render50/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "render50";
  };
})
