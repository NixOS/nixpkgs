{
  lib,
  python3Packages,
  fetchFromGitHub,

  # tests
  addBinToPathHook,
  bc,
  jq,
  versionCheckHook,
}:

let
  finalAttrs = {
    pname = "pyp";
    version = "1.3.0";

    src = fetchFromGitHub {
      owner = "hauntsaninja";
      repo = "pyp";
      tag = "v${finalAttrs.version}";
      hash = "sha256-u9yxjYNQrtYtFtUh5tTJ1mGmGB+Ry+FRupli8RzRu3c=";
    };

    pyproject = true;

    build-system = with python3Packages; [
      flit-core
    ];

    nativeCheckInputs =
      (with python3Packages; [
        pytestCheckHook
      ])
      ++ [
        addBinToPathHook
        bc
        jq
        versionCheckHook
      ];
    versionCheckProgramArg = "--version";

    pythonImportsCheck = [
      "pyp"
    ];

    meta = {
      homepage = "https://github.com/hauntsaninja/pyp";
      description = "Easily run Python at the shell";
      changelog = "https://github.com/hauntsaninja/pyp/blob/${finalAttrs.version}/CHANGELOG.md";
      license = with lib.licenses; [ mit ];
      mainProgram = "pyp";
      maintainers = with lib.maintainers; [
        rmcgibbo
      ];
    };
  };
in
python3Packages.buildPythonPackage finalAttrs
