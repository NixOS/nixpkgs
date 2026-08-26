{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "kalamine";
  version = "0.40";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OneDeadKey";
    repo = "kalamine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9R8N5p+VNuiqTl3a0SSmJEVg3Ol76nROf43GsdOdJL8=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    click
    livereload
    lxml
    progress
    pyyaml
    tomli
  ];

  pythonImportsCheck = [ "kalamine" ];

  # https://github.com/OneDeadKey/kalamine/blob/a9724bf6e93a34c740f9349b8811b2e51cc62c41/Makefile#L39
  preCheck = ''
    python -m kalamine.cli build layouts/*.toml
  '';

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "Keyboard Layout Maker";
    homepage = "https://github.com/OneDeadKey/kalamine/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xaltsc ];
    mainProgram = "kalamine";
  };
})
