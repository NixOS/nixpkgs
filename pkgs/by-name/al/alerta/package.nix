{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "alerta";
  version = "8.5.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ePvT2icsgv+io5aDDUr1Zhfodm4wlqh/iqXtNkFhS10=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    click
    requests
    requests-hawk
    pytz
    tabulate
  ];

  doCheck = true;

  pythonImportsCheck = [ "alertaclient" ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    requests-mock
  ];

  # AlertTestCases attempt to connect to alerta api
  disabledTests = [ "AlertTestCase" ];

  meta = {
    homepage = "https://alerta.io";
    description = "Alerta Monitoring System command-line interface";
    mainProgram = "alerta";
    license = lib.licenses.asl20;
  };
})
