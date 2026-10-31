{
  fetchFromGitHub,
  lib,
  python3Packages,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonPackage rec {
  pname = "nixoscope";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "giomf";
    repo = "nixoscope";
    tag = "v${version}";
    hash = "sha256-Q4WuRpI2CdZx/JLP9SbmI2mz71oU1Fcjw/czvXinH8c=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    graphviz
    mermaid-py
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  unittestFlags = [
    "-s"
    "tests"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Visualize dependencies between NixOS modules";
    homepage = "https://github.com/giomf/NixoScope";
    license = with lib.licenses; [
      mit
    ];
    maintainers = with lib.maintainers; [
      giomf
    ];
    mainProgram = "nixoscope";
  };
}
