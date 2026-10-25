{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "djlint";
  version = "1.43.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "djlint";
    repo = "djlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pw6EIlRJsHK5B1+WD59HzU2Fi6VzPmFXBauypqUwD+I=";
  };

  build-system = with python3.pkgs; [
    hatchling
  ];

  pythonRelaxDeps = [
    "pathspec"
    "regex"
  ];

  dependencies = with python3.pkgs; [
    click
    cssbeautifier
    jsbeautifier
    json5
    pathspec
    pyyaml
    regex
    tomli
  ];

  pythonImportsCheck = [ "djlint" ];

  meta = {
    description = "HTML Template Linter and Formatter. Django - Jinja - Nunjucks - Handlebars - GoLang";
    mainProgram = "djlint";
    homepage = "https://github.com/djlint/djLint";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/djlint/djLint/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ traxys ];
  };
})
