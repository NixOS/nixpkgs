{
  lib,
  python3Packages,
  fetchFromGitHub,
  libclang,
  icdiff,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "style50";
  version = "2.10.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "style50";
    tag = "v${version}";
    hash = "sha256-59V3QZMYH5edBXv1GNdoaQxerDfKmLKUZ7VL3cvDvuE=";
  };

  # setup.py has a non-python package dep which is fulfilled but
  # not correctly detected. Remove the check.
  postPatch = ''
    sed -i '22d' setup.py
  '';

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    autopep8
    icdiff
    jinja2
    jsbeautifier
    libclang
    pycodestyle
    python-magic
    termcolor
  ];

  pythonRelaxDeps = [
    "pycodestyle"
  ];

  pythonImportsCheck = [ "style50" ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  # no python tests

  meta = {
    description = "Tool for checking code against the CS50 style guide";
    homepage = "https://cs50.readthedocs.io/style50/";
    downloadPage = "https://github.com/cs50/style50";
    changelog = "https://github.com/cs50/style50/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "style50";
  };
}
