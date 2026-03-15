{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "linkml";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linkml";
    repo = "linkml";
    rev = "v${version}";
    hash = "sha256-9UFjro2z/LBOMS5RtrVmObvjBLtFPnqPLLYMdCV6gvg=";
  };

  # The installable application lives under packages/linkml and depends on the sibling packages/linkml_runtime.
  # Pointing the build at the sub-package directly.
  sourceRoot = "${src.name}/packages/linkml";

  build-system = with python3Packages; [
    hatchling
    uv-dynamic-versioning
    hatch-vcs
  ];

  # linkml-runtime is a sibling workspace package bundled in the same repo.
  propagatedBuildInputs =
    let
      linkml-runtime = python3Packages.buildPythonPackage {
        pname = "linkml-runtime";
        inherit version src;
        sourceRoot = "${src.name}/packages/linkml_runtime";
        pyproject = true;
        build-system = with python3Packages; [
          hatchling
          uv-dynamic-versioning
          hatch-vcs
        ];
        propagatedBuildInputs = with python3Packages; [
          click
          curies
          deprecated
          hbreader
          jsonasobj2
          jsonschema
          prefixcommons
          prefixmaps
          pydantic
          pyyaml
          rdflib
          requests
        ];
        pythonImportsCheck = [ "linkml_runtime" ];
      };
    in
    with python3Packages;
    [
      linkml-runtime
      antlr4-python3-runtime
      click
      graphviz
      hbreader
      isodate
      jinja2
      jsonasobj2
      jsonschema
      openpyxl
      parse
      pydantic
      pyyaml
      rdflib
      requests
      typing-extensions
    ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-snapshot
  ];

  pytestFlagsArray = [
    "-m"
    "not network and not slow and not docker and not kroki"
  ];

  pythonImportsCheck = [ "linkml" ];

  meta = {
    description = "Linked Data Modeling Language — schema tooling and code generators";
    longDescription = ''
      LinkML is a linked data modeling language following object-oriented and
      ontological principles. Models are authored in YAML and can be converted
      to JSON Schema, OWL, SHACL, ShEx, SQL DDL, Pydantic, and many other
      formats via a rich set of bundled generators.
    '';
    homepage = "https://linkml.io/linkml";
    changelog = "https://github.com/linkml/linkml/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "gen-python";
  };
}
