{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pandoc-plantuml-filter";
  version = "0.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-9qXeIZuCu44m9EoPCPL7MgEboEwN91OylLfbkwhkZYQ=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [ pandocfilters ];

  meta = {
    homepage = "https://github.com/timofurrer/pandoc-plantuml-filter";
    description = "Pandoc filter which converts PlantUML code blocks to PlantUML images";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cmcdragonkai
      l33tname
    ];
    mainProgram = "pandoc-plantuml";
  };
})
