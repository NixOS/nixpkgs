{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "modelscan";
  version = "0.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "protectai";
    repo = "modelscan";
    tag = "v${version}";
    hash = "sha256-8VupkPiHebVtOqMdtkBflAI1zPRdDSvHCEq3ghjASaE=";
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
    ++ lib.flatten (builtins.attrValues optional-dependencies);

  # tensorflow doesn0t support Python 3.12
  doCheck = false;

  pythonImportsCheck = [ "modelscan" ];

  meta = with lib; {
    description = "Protection against Model Serialization Attacks";
    homepage = "https://github.com/protectai/modelscan";
    changelog = "https://github.com/protectai/modelscan/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "modelscan";
  };
}
