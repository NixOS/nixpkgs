{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "djlint";
  version = "1.36.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Riverside-Healthcare";
    repo = "djlint";
    tag = "v${version}";
    hash = "sha256-1DXBDVe8Ae8joJOYwwlBZB8MVubDPVhh+TiJBpL2u2M=";
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
    changelog = "https://github.com/djlint/djLint/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ traxys ];
  };
}
