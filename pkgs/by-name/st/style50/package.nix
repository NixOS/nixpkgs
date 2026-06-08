{
  lib,
  python3Packages,
  fetchFromGitHub,
  djhtml,
  libclang,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "style50";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "style50";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D2ucfVVGZFzmcAUyOfu97QJ8x9pzRo1hYrwZlV8MRN8=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    autopep8
    cssbeautifier
    djhtml
    icdiff
    jinja2
    jsbeautifier
    pycodestyle
    python-magic
    sqlparse
    termcolor
  ];

  preFixup = ''
    makeWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        libclang # clang-format
      ]
    })
  '';

  pythonRelaxDeps = [
    "pycodestyle"
  ];

  pythonRemoveDeps = [
    "clang-format"
  ];

  pythonImportsCheck = [ "style50" ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    versionCheckHook
  ];

  meta = {
    description = "Tool for checking code against the CS50 style guide";
    homepage = "https://cs50.readthedocs.io/style50/";
    downloadPage = "https://github.com/cs50/style50";
    changelog = "https://github.com/cs50/style50/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "style50";
  };
})
