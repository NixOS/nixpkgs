{
  lib,
  git,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "copier";
  version = "9.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "copier-org";
    repo = "copier";
    tag = "v${version}";
    # Conflict on APFS on darwin
    postFetch = ''
      rm $out/tests/demo/doc/ma*ana.txt
    '';
    hash = "sha256-mezmXrOvfqbZGZadNZklQZt/OEKqRYnwugNkZc88t6o=";
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

  makeWrapperArgs = [ "--suffix PATH : ${lib.makeBinPath [ git ]}" ];

  meta = {
    description = "Library and command-line utility for rendering projects templates";
    homepage = "https://copier.readthedocs.io";
    changelog = "https://github.com/copier-org/copier/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ greg ];
    mainProgram = "copier";
  };
}
