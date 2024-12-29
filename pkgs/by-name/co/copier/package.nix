{
  lib,
  git,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "copier";
  version = "9.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "copier-org";
    repo = "copier";
    rev = "refs/tags/v${version}";
    # Conflict on APFS on darwin
    postFetch = ''
      rm $out/tests/demo/doc/ma*ana.txt
    '';
    hash = "sha256-fjZ2ieyyFvm5LdCoKLhOffWZusYbZEGebR8o7PDF8wc=";
  };

  POETRY_DYNAMIC_VERSIONING_BYPASS = version;

  build-system = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python3.pkgs; [
    colorama
    decorator
    dunamai
    funcy
    iteration-utilities
    jinja2
    jinja2-ansible-filters
    mkdocs-material
    mkdocs-mermaid2-plugin
    mkdocstrings
    packaging
    pathspec
    plumbum
    pydantic
    pygments
    pyyaml
    pyyaml-include
    questionary
  ];

  makeWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ git ]}"
  ];

  meta = with lib; {
    description = "Library and command-line utility for rendering projects templates";
    homepage = "https://copier.readthedocs.io";
    changelog = "https://github.com/copier-org/copier/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ greg ];
    mainProgram = "copier";
  };
}
