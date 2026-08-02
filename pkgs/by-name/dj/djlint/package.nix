{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "djlint";
  version = "1.43.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "djlint";
    repo = "djlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PghSw3XeC2rJgRM1O7OQ+R01kdXr0IoMhkuEcM2grKM=";
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
