{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "djlint";
  version = "1.39.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Riverside-Healthcare";
    repo = "djlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vW1K8z4kPoPEHG2OCuZnIkJUo6zHWiA88QlyrSunMh4=";
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
    colorama
    cssbeautifier
    jsbeautifier
    json5
    pathspec
    pyyaml
    regex
    tomli
    tqdm
  ];

  pythonImportsCheck = [ "djlint" ];

  meta = {
    description = "HTML Template Linter and Formatter. Django - Jinja - Nunjucks - Handlebars - GoLang";
    mainProgram = "djlint";
    homepage = "https://github.com/Riverside-Healthcare/djlint";
    license = lib.licenses.gpl3Only;
    changelog = "https://github.com/djlint/djLint/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ traxys ];
  };
})
