{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "spraycharles";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tw1sm";
    repo = "spraycharles";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HQ57+LBBlpjPnmgbh4+esRoIgTSE7+4JYRwHE8CTb1c=";
  };

  pythonRelaxDeps = true;

  # https://github.com/Tw1sm/spraycharles/pull/34
  pythonRemoveDeps = [ "pymsteams" ];
  patches = [ ./drop-teams.patch ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    discord-webhook
    impacket
    numpy
    pyyaml
    requests
    requests-ntlm
    rich
    typer
    typer-config
  ];

  pythonImportsCheck = [ "spraycharles" ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Low and slow password spraying tool";
    homepage = "https://github.com/Tw1sm/spraycharles";
    changelog = "https://github.com/Tw1sm/spraycharles/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "spraycharles";
  };
})
