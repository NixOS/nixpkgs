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
    flit-core,
    lib,
    makeWrapper,
    pydantic,
    pyright,
    rich,
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
          ./cuda_redist_lib
          ./tensorrt
        ];
      };
      nativeBuildInputs = [ makeWrapper ];
      build-system = [ flit-core ];
      dependencies = [
        annotated-types
        pydantic
        rich
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
          echo "Verifying type completeness with pyright"
          pyright --verifytypes ${finalAttrs.pname} --ignoreexternal
        ''
        # postCheck
        + ''
          runHook postCheck
        '';
      postInstall = ''
        mkdir -p "$out/share"
        cp -r "$src/tensorrt" "$out/share"
        wrapProgram "$out/bin/mk-index-of-sha256-and-relative-path" \
          --set TENSORRT_MANIFEST_DIR "$out/share/tensorrt"
      '';
      meta = with lib; {
        description = pyprojectAttrs.project.description;
        homepage = pyprojectAttrs.project.urls.Homepage;
        maintainers = with maintainers; [ connorbaker ];
        mainProgram = "mk-index-of-sha256-and-relative-path";
      };
    };
  in
  buildPythonPackage finalAttrs
)
