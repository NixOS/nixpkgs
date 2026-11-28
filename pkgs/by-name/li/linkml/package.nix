{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "linkml";
  version = "1.12.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "linkml";
    repo = "linkml";
    rev = "v${version}";
    hash = "sha256-1L2uzNJRzUtEnLCUg1JktiWybNvTLhtnR00oRyGrnaU=";
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
      # LinkML 1.12 requires Pydantic 2.13.5; keep curies on the same
      # package-local variant so its transitive dependency does not pull the
      # incompatible nixpkgs default Pydantic into the environment.
      curies = python3Packages.curies.override {
        pydantic = python3Packages.pydantic_2_13_5;
      };
      prefixmaps = python3Packages.prefixmaps.override {
        inherit curies;
      };
      openapi-schema-validator = python3Packages.openapi-schema-validator.override {
        pydantic = python3Packages.pydantic_2_13_5;
        pydantic-settings = python3Packages.pydantic-settings_2_15_0;
      };
      openapi-spec-validator = python3Packages.openapi-spec-validator.override {
        inherit openapi-schema-validator;
      };
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
        propagatedBuildInputs = lib.flatten (
          with python3Packages;
          [
            click
            curies
            deprecated
            hbreader
            isodate
            json-flattener
            jsonasobj2
            jsonschema
            jsonschema.optional-dependencies.format
            prefixcommons
            prefixmaps
            pydantic_2_13_5
            pyyaml
            rdflib
            requests
            pyoxigraph_0_5_11
          ]
        );
        preInstallCheck = ''
          export PYSTOW_HOME="$TMPDIR/pystow-home"
        '';
        pythonImportsCheck = [ "linkml_runtime" ];
      };
    in
    lib.flatten (
      with python3Packages;
      [
        linkml-runtime
        antlr4-python3-runtime_4_9
        click
        curies
        graphviz
        hbreader
        isodate
        jinja2
        jsonasobj2
        jsonschema
        jsonschema.optional-dependencies.format
        openpyxl
        openapi-spec-validator
        parse
        platformdirs_4_12_2
        pyjsg
        pydantic_2_13_5
        pydantic-settings_2_15_0
        prefixcommons
        prefixmaps
        pyshex
        pyshexc
        python-dateutil
        pyyaml
        rdflib
        requests
        sphinx-click
        sqlalchemy_2_0_54
        watchdog
        pyoxigraph_0_5_11
        typing-extensions
      ]
    );

  preInstallCheck = ''
    export PYSTOW_HOME="$TMPDIR/pystow-home"
  '';
  # This package subproject ships no tests; runtime dependency and import checks still run.
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
