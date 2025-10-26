{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "past-time";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabaff";
    repo = "past-time";
    tag = finalAttrs.version;
    hash = "sha256-NSuU33vuHbgJ+cG0FrGYLizIrG7jSz+veptt3D4UegY=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    tqdm
  ];

  nativeCheckInputs = with python3.pkgs; [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "past_time"
  ];

  meta = {
    description = "Tool to visualize the progress of the year based on the past days";
    homepage = "https://github.com/fabaff/past-time";
    changelog = "https://github.com/fabaff/past-time/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "past-time";
  };
})
