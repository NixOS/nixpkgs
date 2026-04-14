{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "past-time";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fabaff";
    repo = "past-time";
    tag = finalAttrs.version;
    hash = "sha256-1t43GAcA3Dd5F2xO0JMmq8f5cbmmcO2I7TIGaVa1ebw=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    cyclopts
    tqdm
  ];

  nativeCheckInputs = with python3.pkgs; [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "past_time" ];

  meta = {
    description = "Tool to visualize the progress of the year based on the past days";
    homepage = "https://github.com/fabaff/past-time";
    changelog = "https://github.com/fabaff/past-time/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "past-time";
  };
})
