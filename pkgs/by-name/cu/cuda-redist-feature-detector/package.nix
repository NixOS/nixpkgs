{ lib, python312Packages }:
let
  inherit (lib.fileset) toSource unions;
  inherit (lib.trivial) flip importTOML;
  callPackage = flip python312Packages.callPackage { };
  pyprojectAttrs = importTOML ./pyproject.toml;
in
callPackage (
  {
    annotated-types,
    buildPythonPackage,
    cuda-redist-lib,
    flit-core,
    lib,
    pydantic,
    pyright,
    ruff,
  }:
  let
    finalAttrs = {
      pname = pyprojectAttrs.project.name;
      inherit (pyprojectAttrs.project) version;
      pyproject = true;
      src = toSource {
        root = ./.;
        fileset = unions [
          ./pyproject.toml
          ./cuda_redist_feature_detector
        ];
      };
      build-system = [ flit-core ];
      dependencies = [
        annotated-types
        cuda-redist-lib
        pydantic
      ];
      pythonImportsCheck = [ finalAttrs.pname ];
      nativeCheckInputs = [
        pyright
        ruff
      ];
      passthru.optional-dependencies.dev = [
        pyright
        ruff
      ];
      doCheck = true;
      checkPhase =
        # preCheck
        ''
          runHook preCheck
        ''
        # Check with ruff
        + ''
          echo "Linting with ruff"
          ruff check
          echo "Checking format with ruff"
          ruff format --diff
        ''
        # Check with pyright
        + ''
          echo "Typechecking with pyright"
          pyright --warnings
        ''
        # postCheck
        + ''
          runHook postCheck
        '';
      meta = with lib; {
        description = pyprojectAttrs.project.description;
        homepage = pyprojectAttrs.project.urls.Homepage;
        maintainers = with maintainers; [ connorbaker ];
      };
    };
  in
  buildPythonPackage finalAttrs
)
