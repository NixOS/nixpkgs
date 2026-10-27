{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "alerta";
  version = "8.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alerta";
    repo = "python-alerta-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6J5BL+Tn3VoDq+K2jEGiqjd9k73qnsw2ctAIc/MrJLQ=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    click
    requests
    requests-hawk
    pytz
    tabulate
  ];

  pythonImportsCheck = [ "alertaclient" ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    requests-mock
  ];

  # AlertTestCases attempt to connect to alerta api
  disabledTests = [ "AlertTestCase" ];

  meta = {
    homepage = "https://alerta.io";
    description = "Monitoring System command-line interface";
    mainProgram = "alerta";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
