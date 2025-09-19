{
  fetchFromGitHub,
  lib,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "semgrep-search";
  version = "1.1.0";
  pyproject = true;
  pythonRelaxDeps = true;

  src = fetchFromGitHub {
    owner = "hnzlmnn";
    repo = "semgrep-search";
    tag = "v${version}";
    hash = "sha256-Rhz7bd5YdR2l03Z9naj1ozj7HbpvEk6gd1YAJiGFL/U=";
  };

  dependencies = with python3Packages; [
    babel
    oras
    poetry-core
    pyyaml
    requests
    rich
    ruamel-yaml
    semver
    tinydb
    tomli
  ];

  build-system = [ python3Packages.poetry-core ];

  meta = {
    changelog = "https://github.com/hnzlmnn/semgrep-search/releases/v${version}";
    description = "CLI tool generating semgrep rulesets using an external semgrep rules database";
    homepage = "https://github.com/hnzlmnn/semgrep-search";
    license = lib.licenses.gpl3;
    longDescription = "semgrep-search generates custom YAML rulesets using an external rules database published at ghcr.io/hnzlmnn/semgrep-search-db.";
    mainProgram = "sgs";
    maintainers = with lib.maintainers; [ cryptoluks ];
    platforms = lib.platforms.all;
  };
}
