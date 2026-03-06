{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "modelscan";
  version = "0.8.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "protectai";
    repo = "modelscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mN2X6Zbai7xm8bdr2hi9fwzIsfQtukeGcOIS32G4hA0=";
  };

  pythonRelaxDeps = [ "rich" ];

  build-system = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python3.pkgs; [
    click
    numpy
    rich
    tomlkit
  ];

  optional-dependencies = with python3.pkgs; {
    h5py = [ h5py ];
    # tensorflow = [ tensorflow ];
  };

  nativeCheckInputs =
    with python3.pkgs;
    [
      dill
      pytestCheckHook
    ]
    ++ lib.concatAttrValues optional-dependencies;

  # tensorflow doesn0t support Python 3.12
  doCheck = false;

  pythonImportsCheck = [ "modelscan" ];

  meta = {
    description = "Protection against Model Serialization Attacks";
    homepage = "https://github.com/protectai/modelscan";
    changelog = "https://github.com/protectai/modelscan/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "modelscan";
  };
})
